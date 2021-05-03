pro test_change

  tlb=widget_base(xsize=550,ysize=500,tlb_frame_attr=1,title='Change dection')
  base1 = widget_base(tlb,xsize = 500, ysize = 450,xoffset = 25, yoffset = 25, frame = 1 )

  labelIn1 = widget_label( base1, value = 'Input initial data',xoffset = 10,yoffset = 10 )
  textIn1= widget_text( base1,  xsize = 40, ysize = 1, xoffset = 10, yoffset = 25, uname = 'textIn1' )
  btnOpen1 = widget_button(base1, value = 'Open', xsize = 70, ysize = 25, xoffset = 350, yoffset = 25, uname = 'Open1' )

  labelIn2 = widget_label( base1, value = 'Input later data',xoffset = 10,yoffset = 60 )
  textIn2 = widget_text( base1,  xsize = 40, ysize = 1, xoffset = 10, yoffset = 75, uname = 'textIn2' )
  btnOpen2 = widget_button(base1, value = 'Open', xsize = 70, ysize = 25, xoffset = 350, yoffset = 75, uname = 'Open2' )

  labelIn3 = widget_label( base1, value = 'Out put change file',xoffset = 10,yoffset = 110 )
  textIn3 = widget_text( base1,  xsize = 40, ysize = 1, xoffset = 10, yoffset = 125, uname = 'textSave1' )
  btnOpen3 = widget_button(base1, value = 'Save', xsize = 70, ysize = 25, xoffset = 350, yoffset = 125, uname = 'Save1' )
  
  labelIn4 = widget_label( base1, value = 'Out put qiangdu file',xoffset = 10,yoffset = 160 )
  textIn4 = widget_text( base1,  xsize = 40, ysize = 1, xoffset = 10, yoffset = 175, uname = 'textSave2' )
  btnOpen4 = widget_button(base1, value = 'Save', xsize = 70, ysize = 25, xoffset = 350, yoffset = 175, uname = 'Save2' )
  
  labelIn5 = widget_label( base1, value = 'Out put BianHua file',xoffset = 10,yoffset = 210 )
  textIn5 = widget_text( base1,  xsize = 40, ysize = 1, xoffset = 10, yoffset = 225, uname = 'textSave3' )
  btnOpen5 = widget_button(base1, value = 'Save', xsize = 70, ysize = 25, xoffset = 350, yoffset = 225, uname = 'Save3' )

  button=widget_button(base1,value='Run',xsize=70,ysize=25,xoffset=350,yoffset=300,uname='Run')
  button=widget_button(base1,value='Next->',xsize=70,ysize=25,xoffset=430,yoffset=300,uname='Next')

  widget_control,tlb,/realize
  xmanager, 'test_change', tlb, /no_block
end

pro test_change_event, ev
  ;获取textIn、textSave控件的id
   uname = widget_info(ev.id, /uname)  ;获取触发事件的控件的uname
  textIn1= widget_info(ev.top, find_by_uname = 'textIn1')
  textIn2 = widget_info(ev.top, find_by_uname = 'textIn2')
  textSave1= widget_info(ev.top, find_by_uname = 'textSave1')
  textSave2= widget_info(ev.top, find_by_uname = 'textSave2')
  textSave3= widget_info(ev.top, find_by_uname = 'textSave3')
    
  case uname of
    'Open1' : begin  ;如果点击Open按钮，则执行以下操作
      compile_opt idl2
      ENVI,/restore_base_save_file
      ENVI_Batch_Init
      file1=dialog_pickfile()
      widget_control,textIn1,set_value=file1
      ENVI_OPEN_FILE,file1,r_fid=fid
      if(fid eq -1) then return
      ENVI_FIlE_QUERY,fid,dims=dims,nb=nb,ns=ns,nl=nl,wl=wl
      data1=uintarr(ns,nl,nb)
      for i=0,nb-1 do begin
        temp1=ENVI_GET_DATA(fid=fid,DIMS=dims,pos=i)
        data1[*,*,i]=temp1 
      endfor
    end
    'Open2' : begin  ;如果点击Save按钮，则执行以下操作
      ENVI,/restore_base_save_file
      ENVI_Batch_Init
      file2=dialog_pickfile()
      widget_control,textIn2,set_value=file2
      ENVI_OPEN_FILE,file2,r_fid=fid
      ENVI_FIlE_QUERY,fid,dims=dims,nb=nb,ns=ns,nl=nl,wl=wl
      data2=uintarr(ns,nl,nb)
      for i=0,nb-1 do begin
       temp2=ENVI_GET_DATA(fid=fid,DIMS=dims,pos=i)
       data2[*,*,i]=temp2
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
    'Save3' : begin  ;如果点击Run按钮，则执行以下操作
      fileOut3 = dialog_pickfile(/write)  ;保存文件对话框
      widget_control, textSave3, set_value = fileOut3  ;修改文本框内容
    end
    
    'Run' : begin  ;如果点击Run按钮，则执行以下操作
      widget_control,textIn1,get_value=file1
      widget_control,textIn2,get_value=file2
      widget_control,textSave1,get_value=fileout1
      widget_control,textSave2,get_value=fileout2
      widget_control,textSave3,get_value=fileout3
      envi,/restore_base_save_files
      envi_batch_init
      envi_open_file,file1,r_fid=fid
      ENVI_FILE_QUERY, fid, DIMS=dims, nb=nb,ns=ns,nl=nl,wl=wl
      data1=dblarr(ns,nl,nb)
      for i=0,nb-1 do begin
       temp1=ENVI_GET_DATA(fid=fid,DIMS=dims,pos=i)
       data1[*,*,i]=temp1
      endfor
      envi_open_file,file2,r_fid=fid
      ENVI_FILE_QUERY, fid, DIMS=dims, nb=nb,ns=ns,nl=nl,wl=wl
      data2=dblarr(ns,nl,nb)
      for i=0,nb-1 do begin
       temp2=ENVI_GET_DATA(fid=fid,DIMS=dims,pos=i)
        data2[*,*,i]=temp2
      endfor
       change=uintarr(ns,nl,nb)
       data=dblarr(ns,nl)
      
      for i=0,nb-1 do begin
        temp3=data2[*,*,i]-data1[*,*,i]
        change[*,*,i]=temp3
      endfor
     
      temp=dblarr(ns,nl)
        for k=0,nb-1 do begin
           temp[*,*]=temp[*,*]+change[*,*,k]^2
        endfor 
     data[*,*]=sqrt(temp[*,*])
     
     Otsu = IMAGE_THRESHOLD(data,THRESHOLD=o,/otsu)
     PRINT,o
      
      BianHua=dblarr(ns,nl,nb)
      for i=0,nb-1 do begin
        temp4 = Otsu[*,*,*]*change[*,*,i]
        BianHua[*,*,i]=temp4
      endfor
  
     tvscl,Otsu
      envi_write_envi_file,change,out_name=fileOut1,nb = nb,ns=ns,nl=nl
      envi_write_envi_file,data,out_name=fileOut2,nb = 1,ns=ns,nl=nl
      envi_write_envi_file,BianHua,out_name=fileOut3,nb = nb,ns=ns,nl=nl
      tmp=dialog_message('successful',/info)
    end
    
    'Next':begin
      test_readROI
      end
  endcase
end