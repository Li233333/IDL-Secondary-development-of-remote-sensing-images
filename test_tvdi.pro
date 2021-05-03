Pro test_TVDI
  tlb=widget_base(xsize=800,ysize=560,tlb_frame_attr=1,title='TVDI calculate')

  button=widget_button(tlb,value='exit',xsize=100,ysize=30,xoffset=600,yoffset=500)
  button1=widget_button(tlb,value='calculate',xsize=100,ysize=30,xoffset=450,yoffset=500,uname = 'calculate')
  base1 = widget_base(tlb,xsize = 300,ysize = 450,xoffset = 25,yoffset = 25, frame = 1)
  base2 = widget_base(tlb,xsize = 425,ysize = 450,xoffset = 350,yoffset = 25,frame = 1)
  
  draw = widget_draw(base1, xsize = 300,ysize = 440, xoffset = 0, yoffset = 5, uname='draw1')
  
  labelIn = widget_label(base2,value = 'Ts',xoffset = 10, yoffset = 10)
  textIn = widget_text( base2, xsize = 40, ysize = 1,xoffset = 10,yoffset = 25, uname = 'textIn')
  btnOpen = widget_button(base2,value = 'Open',xsize = 70,ysize = 25,xoffset = 350,yoffset = 25,uname = 'buttonIn')
  
  labelIn1 = widget_label(base2,value = 'Tmax',xoffset = 10,yoffset = 100)
  textIn1 = widget_text( base2,xsize = 40,ysize = 1,xoffset = 10,yoffset = 115,uname = 'text')
  btnOpen1 = widget_button(base2,value = 'Open',xsize = 70,ysize = 25,xoffset = 350,yoffset = 115,uname = 'open')

  labelOut2 = widget_label(base2,value = 'Tmin',xoffset = 10,yoffset = 205)
  textIn2 = widget_text(base2,xsize = 40,ysize = 1,xoffset = 10,yoffset = 220,uname = 'texti' )
  btnOpen2 = widget_button(base2,value = 'open',xsize = 70,ysize = 25,xoffset = 350,yoffset = 220,uname = 'buttonopen')
  
  labelOut = widget_label(base2,value = 'save file',xoffset = 10,yoffset = 325)
  textIn = widget_text(base2,xsize = 40,ysize = 1,xoffset = 10,yoffset = 340,uname = 'textSave')
  btnOpen = widget_button(base2,value = 'Save',xsize = 70,ysize = 25,xoffset = 350,yoffset = 340,uname = 'buttonSave')


  widget_control,tlb,/realize
  widget_control,draw,get_value = win ;获取图像控件的窗口ID
  widget_control,tlb,set_uvalue = win ;保存图像控件的窗口ID
  xmanager, 'test_TVDI', tlb, /no_block
end

pro test_TVDI_event, ev
  ;获取textIn、textSave控件的id
  compile_opt idl2
  textIn = widget_info(ev.top, find_by_uname = 'textIn')
  textIn1 = widget_info(ev.top, find_by_uname = 'text')
  textIn2 = widget_info(ev.top, find_by_uname = 'texti')
  textSave = widget_info(ev.top, find_by_uname = 'textSave')
  uname = widget_info(ev.id, /uname)  ;获取触发事件的控件的uname
  case uname of
    'buttonIn' : begin  ;如果点击Open按钮，则执行以下操作
      envi,/restore_base_save_files
      envi_batch_init
      file=dialog_pickfile(/read)
      widget_control,textin,set_value=file
      envi_open_file,file,r_fid=fid
      ENVI_FILE_QUERY, fid, DIMS=dims, NB=nb,ns=ns,nl=nl
      data1=uintarr(ns,nl)
      data1=envi_get_data(fid=fid,dims=dims,pos=0)
      data1=congrid(data1,300,450)
      widget_control, ev.top, get_uvalue = win1
      wset, win1
      tvscl,data1
    end
    'open' : begin  ;如果点击Open按钮，则执行以下操作
      envi,/restore_base_save_files
      envi_batch_init
      file1=dialog_pickfile()
      widget_control,textIn1,set_value=file1
      envi_open_file,file1,r_fid=fid
      ENVI_FILE_QUERY, fid, DIMS=dims, NB=nb,ns=ns,nl=nl,wl=wl
      data2=uintarr(ns,nl)
      data2=envi_get_data(fid=fid,dims=dims,pos=0)
      data2=congrid(data2,300,450)
      widget_control, ev.top, get_uvalue = win1
      wset, win1
      tvscl,data2
    end
    'buttonopen' : begin  ;如果点击Open按钮，则执行以下操作
      envi,/restore_base_save_files
      envi_batch_init
      file2=dialog_pickfile()
      widget_control,textIn2,set_value=file2
      envi_open_file,file2,r_fid=fid
      ENVI_FILE_QUERY, fid, DIMS=dims, NB=nb,ns=ns,nl=nl,wl=wl
      data3=uintarr(ns,nl)
      data3=envi_get_data(fid=fid,dims=dims,pos=0)
      data3=congrid(data3,300,450)
      widget_control, ev.top, get_uvalue = win1
      wset, win1
      tvscl,data3
    end
    'calculate' : begin
      widget_control, textIn, get_value = file  ;获取文本框内容
      widget_control, textIn1, get_value = file1  ;获取文本框内容
      widget_control, textIn2, get_value = file2  ;获取文本框内容
      widget_control, textSave, get_value = fileOut  ;获取文本框内容
      envi,/restore_base_save_files
      envi_batch_init
      envi_open_file,file, r_fid=fid
      envi_file_query, fid, ns=ns, nl=nl, nb=nb, dims=dims,wl=wl
      data1=uintarr(ns,nl)
      Ts=envi_get_data(fid=fid, dims=dims, pos=0)
      envi_batch_init
      envi_open_file,file1, r_fid=fid
      envi_file_query, fid, ns=ns, nl=nl, nb=nb, dims=dims,wl=wl
      data2=uintarr(ns,nl)
      Tmax=envi_get_data(fid=fid, dims=dims, pos=0)
      envi_batch_init
      envi_open_file,file2, r_fid=fid
      envi_file_query, fid, ns=ns, nl=nl, nb=nb, dims=dims,wl=wl
      data3=uintarr(ns,nl)
      Tmin=envi_get_data(fid=fid, dims=dims, pos=0)
      TVDI=(Ts-Tmin)/(Tmax-Tmin)

      envi_write_envi_file,TVDI,out_name=fileOut,wl=wl
      tmp=dialog_message('successful',/info)

      TVDI=congrid(TVDI,300,450)
      widget_control, ev.top, get_uvalue = win1
      wset, win1
      tvscl,TVDI

    end
    'buttonSave' : begin  ;如果点击Save按钮，则执行以下操作
      fileOut = dialog_pickfile()  ;保存文件对话框
      widget_control, textSave, set_value = fileOut  ;修改文本框内容

    end
  endcase
end
