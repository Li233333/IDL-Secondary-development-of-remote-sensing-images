pro tm
  tlb = widget_base($
    xsize = 800, $
    ysize = 400, $
    tlb_frame_attr = 1, $
    title = 'Radiometric Correction tm' $
    )
  btnOpen = widget_button( $  ;创建按钮
    tlb, $  ;将按钮添加至tlb容器中
    value = 'Run', $  ;设置按钮上的文字
    xsize = 80, $  ;按钮宽度
    ysize = 30, $  ;按钮高度
    xoffset = 500, $  ;按钮横向位置
    yoffset = 350, $  ;按钮纵向位置
    uname = 'Run' $
    )
  btnOpen = widget_button( $  ;创建按钮
    tlb, $  ;将按钮添加至tlb容器中
    value = 'Next', $  ;设置按钮上的文字
    xsize = 80, $  ;按钮宽度
    ysize = 30, $  ;按钮高度
    xoffset = 650, $  ;按钮横向位置
    yoffset = 350, $  ;按钮纵向位置
    uname = 'Next' $；设置uname
    )
  base1 = widget_base( $  ;创建base1
    tlb, $  ;将base1添加至tlb容器
    xsize = 300, $  ;base宽度
    ysize = 350, $  ;base高度
    xoffset = 25, $  ;横向位置
    yoffset = 25, $  ;纵向位置
    frame = 1 $  ;base1边框样式
    )
  base2 = widget_base( $  ;创建base2
    tlb, $  ;将base2添加至tlb容器
    xsize = 425, $  ;base宽度
    ysize = 300, $  ;base高度
    xoffset = 350, $  ;横向位置
    yoffset = 25, $  ;纵向位置
    frame = 1 $  ;base2边框样式
    )
  draw = widget_draw( $  ;创建图像显示控件
    base1, $  ;将控件添加至base1
    xsize = 280, $  ;控件宽度
    ysize = 340, $  ;控件高度
    xoffset = 10, $  ;横向位置
    yoffset = 5 $  ;纵向位置
    )
  open1 = widget_button( $;创建按钮
    base2, $
    value = 'Open', $
    xsize = 70, $
    ysize = 25, $
    xoffset = 350, $
    yoffset = 25, $
    uname = 'open1' $  ;设置uname
    )
  opendatafile= widget_button( $;创建按钮
    base2, $
    value = 'Open', $
    xsize = 70, $
    ysize = 25, $
    xoffset = 350, $
    yoffset = 120, $
    uname = 'Open2' $  ;设置uname
    )
  openoutputfile=widget_button(  $;创建按钮
    base2,$
    value='Choose',$
    xsize=70,ysize=25,$
    xoffset=350,$
    yoffset=225,$
    uname='Open3'$
    )

  labelIn = widget_label( $  ;创建文字控件
    base2, $  ;添加至base2
    value = 'Open Image File', $  ;文字内容
    xoffset = 10, $  ;横向位置
    yoffset = 10 $  ;纵向位置
    )
  labelIn = widget_label( $  ;创建文字控件
    base2, $  ;添加至base2
    value = 'Open Metedata File', $  ;文字内容
    xoffset = 10, $  ;横向位置
    yoffset = 100 $  ;纵向位置
    )
  labelIn = widget_label( $ ;创建文字控件
    base2,$
    value='Choose Output File', $
    xoffset=10, $
    yoffset=210 $
    )

  imagefile = widget_text( $ ;创建文本框
    base2, $
    xsize = 50, $
    ysize = 1, $
    xoffset = 10, $
    yoffset = 25, $
    uname = 'textIn1' $  ;设置uname
    )
  metedatafile = widget_text( $ ;创建文本框
    base2, $
    xsize = 50, $
    ysize = 1, $
    xoffset = 10, $
    yoffset = 120, $
    uname = 'textIn2' $  ;设置uname
    )
  outfile = widget_text( $ ;创建文本框
    base2,$
    xsize = 50,$
    ysize=1,$
    xoffset=10,$
    yoffset=225,$
    uname='textout' $
    )
  widget_control, tlb,/realize  ;显示容器
  widget_control, draw, get_value = win  ;获取图像控件的窗口ID
  widget_control, tlb, set_uvalue = win  ;保存图像控件的窗口ID
  xmanager ,'tm', tlb ,/no_block
end


pro tm_event,ev
  compile_opt  idl2
  uname=widget_info(ev.id,/uname)
  widget_control,ev.top,get_uvalue=win
  textIn1=widget_info(ev.top,find_by_uname='textIn1')
  textIn2=widget_info(ev.top,find_by_uname='textIn2')
  textout=widget_info(ev.top,find_by_uname='textout')
  case uname of
    ;影像文件的打开和保存核心代码
    'open1':begin
      envi,/restore_base_save_files
      envi_batch_init
      file=dialog_pickfile()
      widget_control,textIn1,set_value=file
      envi_open_file,file,r_fid=fid
      if (fid eq -1) then return
      ENVI_FILE_QUERY, fid, DIMS=dims, NB=nb,ns=ns,nl=nl,wl=wl
      data=uintarr(ns,nl,nb)
      for  i=0,nb-1 do begin
        img=envi_get_data(fid = fid,dims=dims,pos=i)
        data[*,*,i]=img
        image=data[*,*,[4,3,2]]
        image=congrid(image,280,340,3)
        widget_control,ev.top,get_uvalue=d
        wset,win
        tvscl,image,true=3
      endfor
    end

    'Open2':begin
      file1=dialog_pickfile(/read,filter='*.txt')
      widget_control,textIn2,set_value=file1
    end
    'Open3':begin
      fileout=dialog_pickfile(/write)
      widget_control,textout,set_value=fileout
    end
    'Choose':begin
      fileout = dialog_pickfile(/write)
      widget_control,textIn1,set_value=fileout
    end

    'Run':begin
      widget_control,textIn1,get_value=file
      widget_control,textIn2,get_value=file1
      widget_control,textout,get_value=fileout


      ENVI,/restore_base_save_files
      ENVI_Batch_Init
      ENVI_OPEN_FILE,file,R_FID=fid
      ENVI_FILE_QUERY,fid,DIMS=dims,nb=nb,ns=ns,nl=nl,wl=wl
      M=dblarr(7)
      A=dblarr(7)
      str=''
      data=dblarr(ns,nl,7)
      openr,lun,file1,/get_lun
      skip_lun,lun,122,/line
      for i=0,6 do begin
        readf,lun,str
        str1=strmid(str,27,10)
        result1=double(str1)
        m[i]=result1
      endfor
      print,m[0]
      for i=0,6 do begin

        readf,lun,str
        str2=strmid(str,26,9)
        result2=double(str2)
        a[i]=result2
      endfor
      print,a[0]
      free_lun,lun
      for  i=0,6 do begin
        img=envi_get_data(FID=fid,DIMS=dims,POS=i)
        data[*,*,i]=img
      endfor
      ;print,data
      l=dblarr(ns,nl,7)
      for i=0,6 do begin
        l[*,*,i]=((m[i]*data[*,*,i])+A[i])*0.1

      endfor
      image=l[*,*,[3,2,1]]
      image=congrid(image,350,450,3)
      widget_control,ev.top,get_uvalue=d
      wset,d
      tvscl,image,true=3
      envi_write_envi_file,l,out_name=fileout,wl=wl
      tmp=dialog_message('successful',/info)
    end
    'Next':begin
      widget_control,ev.top,/destroy
      testQC
    end
  endcase
end