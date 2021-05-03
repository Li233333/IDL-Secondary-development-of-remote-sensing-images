pro test_readROI
  tlb=widget_base(xsize=550,ysize=350,tlb_frame_attr=1,title='Image Classification')
  base1 = widget_base(tlb,xsize = 500, ysize = 300,xoffset = 25, yoffset = 25, frame = 1 )

  labelIn1 = widget_label( base1, value = 'Select ROIs file',xoffset = 10,yoffset = 10 )
  textIn1= widget_text( base1,  xsize = 40, ysize = 1, xoffset = 10, yoffset = 25, uname = 'textIn1' )
  btnOpen1 = widget_button(base1, value = 'Open', xsize = 70, ysize = 25, xoffset = 350, yoffset = 25, uname = 'Open1' )

  labelIn2 = widget_label( base1, value = 'Input BianHua file',xoffset = 10,yoffset = 60 )
  textIn2 = widget_text( base1,  xsize = 40, ysize = 1, xoffset = 10, yoffset = 75, uname = 'textIn2' )
  btnOpen2 = widget_button(base1, value = 'Open', xsize = 70, ysize = 25, xoffset = 350, yoffset = 75, uname = 'Open2' )

  labelIn3 = widget_label( base1, value = 'Out put yingxiang file',xoffset = 10,yoffset = 110 )
  textIn3 = widget_text( base1,  xsize = 40, ysize = 1, xoffset = 10, yoffset = 125, uname = 'textSave1' )
  btnOpen3 = widget_button(base1, value = 'Save', xsize = 70, ysize = 25, xoffset = 350, yoffset = 125, uname = 'Save1' )
  
  labelIn4 = widget_label( base1, value = 'Out put fenlei file',xoffset = 10,yoffset = 160 )
  textIn4 = widget_text( base1,  xsize = 40, ysize = 1, xoffset = 10, yoffset = 175, uname = 'textSave2' )
  btnOpen4 = widget_button(base1, value = 'Save', xsize = 70, ysize = 25, xoffset = 350, yoffset = 175, uname = 'Save2' )

  button=widget_button(base1,value='Ok',xsize=70,ysize=25,xoffset=350,yoffset=260,uname='Ok')

  widget_control,tlb,/realize
  xmanager, 'test_readROI', tlb, /no_block
end



pro test_readROI_event, ev
compile_opt idl2
  ;获取textIn、textSave控件的id
  uname = widget_info(ev.id, /uname)  ;获取触发事件的控件的uname
  textIn1= widget_info(ev.top, find_by_uname = 'textIn1')
  textIn2= widget_info(ev.top, find_by_uname = 'textIn2')
  textSave1= widget_info(ev.top, find_by_uname = 'textSave1')
  textSave2= widget_info(ev.top, find_by_uname = 'textSave2')

  case uname of
     'Open1' : begin  ;如果点击Open按钮，则执行以下操作
        compile_opt idl2
        ENVI,/restore_base_save_file
        ENVI_Batch_Init
        dn=dialog_pickfile()
        widget_control,textIn1,set_value=dn
        ENVI_RESTORE_ROIS,dn
        ENVI_OPEN_FILE,dn,r_fid=fid
        ENVI_FILE_QUERY,fid,ns=ns,nl=nl,nb=nb,dims=dims
        ENVI_Batch_exit
        end

     'Open2' : begin  ;如果点击Save按钮，则执行以下操作
          ENVI,/restore_base_save_file
          ENVI_Batch_Init
          file2=dialog_pickfile()
          widget_control,textIn2,set_value=file2
          ENVI_OPEN_FILE,file2,r_fid=fid
          ENVI_FIlE_QUERY,fid,dims=dims,nb=nb,ns=ns,nl=nl,wl=wl
          BianHua=uintarr(ns,nl,nb)
          for i=0,nb-1 do begin
            temp1=ENVI_GET_DATA(fid=fid,DIMS=dims,pos=i)
            BianHua[*,*,i]=temp1
          endfor
        end

    'Save1' : begin  ;如果点击Run按钮，则执行以下操作
        fileOut1 = dialog_pickfile(/write)  ;保存文件对话框
        widget_control, textSave1, set_value = fileOut1  ;修改文本框内容
        end
    'Save2' : begin  ;如果点击Run按钮，则执行以下操作
        fileOut2 = dialog_pickfile(/write)  ;保存文件对话框
        widget_control, textSave2, set_value = fileOut2  ;修改文本框内容
        end
    'Ok':begin
       widget_control,textIn1,get_value=dn
       widget_control,textIn2,get_value=file2
       widget_control,textSave1,get_value=fileout1
       widget_control,textSave2,get_value=fileout2
       ENVI,/restore_base_save_file
       ENVI_Batch_Init
       
       ;读取.roi文件
       ENVI_RESTORE_ROIS,dn
       ENVI_OPEN_FILE,dn,r_fid=fid
       ENVI_FILE_QUERY,fid,ns=ns,nl=nl,nb=nb,dims=dims
       widget_control, ev.top, get_uvalue=dn
       ROI_IDS=ENVI_GET_ROI_IDS(dn=dn,roi_names=roi_names,roi_colors=roi_colors)
       ENVI_GET_ROI_INFORMATION,roi_ids,roi_names=roi_names,npts=npts,roi_colors=roi_colors
       
       ;读取影像文件
       ENVI_OPEN_FILE,file2,r_fid=fid
       ENVI_FIlE_QUERY,fid,dims=dims,nb=nb,ns=ns,nl=nl,wl=wl
       BianHua1=uintarr(ns,nl,nb)
       for i=0,nb-1 do begin
         temp1=ENVI_GET_DATA(fid=fid,DIMS=dims,pos=i)
         BianHua1[*,*,i]=temp1
       endfor

       ;获取roi类别数
       result= size(ROI_colors,/DIMENSIONS)
       b=result[1]
  
        name=strarr(1,b)
       YingXiang=reform(BianHua1[*,*,*],ns*nl,6)
       roi_SHUZHI=uintarr(6,ns*nl,b)
       for j=0,5 do begin
         for i=0,b-1 do begin
           roi_address=ENVI_GET_ROI(roi_ids[i],roi_name=roi_name)
           temp2=YingXiang[j,[roi_address]]  ;根据roi下标找出每类roi对应的像元的值存放在数组中
           roi_SHUZHI[j,npts[i],i]=temp2   ;j表示有6列，每一列是一个波段中roi对应的影像像元值，npts表示每一类roi内的像元数，i表示每一类像元
              name[*,i]=roi_name
         endfor
       endfor

         temp3=reform( roi_SHUZHI,b,ns*nl*6);将数据装换成二维，每一列代表一类ROI对应的像元值
          
         mean=mean(temp3,dimension=2);按列求均值
   
         BianHua=reform(BianHua1,ns*nl,6)
         LEI=uintarr(ns*nl,6,b)
         for j=0,b-1 do begin
         temp4=sqrt((BianHua[*,*]-mean[j])^2 ) ;求像元到每类ROI的距离
         LEI[*,*,j]=temp4
         endfor
         
         zew=reform(LEI,ns*nl*6,b)
         px=uintarr(ns*nl*6,b)
         for m=0,ns*nl*6-1 do begin ;对最小距离的roi排序
          temp5=sort(zew[m,*])
          px[m,*]=temp5
         endfor     
         
         temp6=px[*,0] ;排序后第一行为距离最小的roi
         YX=reform(BianHua,ns*nl*6)
         tx=zew[temp6]
         
         envi_write_envi_file, tx,out_name=fileOut1,nb = nb,ns=ns,nl=nl
         envi_write_envi_file, temp6,out_name=fileOut2,nb = nb,ns=ns,nl=nl
         tmp=dialog_message(name,/info)
        end   
    endcase
end