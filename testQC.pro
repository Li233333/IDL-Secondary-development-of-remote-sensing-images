pro testQC
  tlb = widget_base($
    xsize = 800, $
    ysize = 400, $
    tlb_frame_attr = 1, $
    title = 'Quick Atmospheric Correction' $
    )
    run = widget_button( $  ;创建按钮
    tlb, $  ;将按钮添加至tlb容器中
    value = 'Run', $  ;设置按钮上的文字
    xsize = 80, $  ;按钮宽度
    ysize = 30, $  ;按钮高度
    xoffset = 500, $  ;按钮横向位置
    yoffset = 350, $  ;按钮纵向位置
    uname = 'run' $
    )
    next = widget_button( $  ;创建按钮
    tlb, $  ;将按钮添加至tlb容器中
    value = 'Next>', $  ;设置按钮上的文字
    xsize = 80, $  ;按钮宽度
    ysize = 30, $  ;按钮高度
    xoffset = 650, $  ;按钮横向位置
    yoffset = 350, $  ;按钮纵向位置
    uname = 'next' $；设置uname
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
    openimage = widget_button( $;创建按钮
    base2, $
    value = 'Open', $
    xsize = 70, $
    ysize = 25, $
    xoffset = 350, $
    yoffset = 25, $
    uname = 'openimage' $  ;设置uname
    )
   openoutputfile = widget_button( $；创建按钮
    base2, $
    value = 'Choose', $
    xsize = 70, $
    ysize = 25, $
    xoffset = 350, $
    yoffset = 120, $
    uname = 'openoutputfile' $  ;设置uname
    )
 
  labelIn = widget_label( $  ;创建文字控件
    base2, $  ;添加至base2
    value = 'Open Radiometric Correction Result', $  ;文字内容
    xoffset = 10, $  ;横向位置
    yoffset = 10 $  ;纵向位置
    )
  labelIn = widget_label( $  ;创建文字控件
    base2, $  ;添加至base2
    value = 'Choose Output File', $  ;文字内容
    xoffset = 10, $  ;横向位置
    yoffset = 100 $  ;纵向位置
    )
    Radiomfile= widget_text( $ ;创建文本框
    base2, $
    xsize = 50, $
    ysize = 1, $
    xoffset = 10, $
    yoffset = 25, $
    uname = 'textin' $  ;设置uname
    )
    outfile = widget_text( $ ;创建文本框
    base2, $
    xsize = 50, $
    ysize = 1, $
    xoffset = 10, $
    yoffset = 120, $
    uname = 'textout' $  ;设置uname
    )
  widget_control, tlb,/realize  ;显示容器
  widget_control, draw, get_value = d ;获取图像控件的窗口ID
  widget_control, tlb, set_uvalue = d  ;保存图像控件的窗口ID
  xmanager ,'testQC', tlb ,/no_block
end

pro testQC_event,ev
compile_opt idl2
  uname=widget_info(ev.id,/uname)
  widget_control,ev.top,get_uvalue=d
  textin=widget_info(ev.top,find_by_uname='textin')
  textout=widget_info(ev.top,find_by_uname='textout')
  case uname of
    'openimage':begin
    envi,/restore_base_save_files
    envi_batch_init
    file=dialog_pickfile()
    widget_control,textin,set_value=file
    envi_open_file,file,r_fid=fid 
    ; if(fid eq -1) then return
    ENVI_FILE_QUERY, fid, DIMS=dims, NB=nb,ns=ns,nl=nl,wl=wl
    data=uintarr(ns,nl,nb)
    for  i=0,nb-1 do begin
      img=envi_get_data(fid=fid,dims=dims,pos=i)
      data[*,*,i]=img
      image=data[*,*,*]
      image=congrid(image,280,340,3)
      widget_control,ev.top,get_uvalue=d
      wset,d
      tvscl,image,true=3
    endfor
  end

 'openoutputfile':begin
  fileout=dialog_pickfile(/write)
  widget_control,textout,set_value=fileout
end
'run':begin
  widget_control,textin,get_value=filein;获取文本框内容
  widget_control,textout,get_value=fileout;获取文本框内容
  envi,/restore_base_save_files
  envi_batch_init
  ;读取辐射校正结果
  file=filein
  envi_open_file,file,r_fid=fid
  envi_file_query,fid,dims=dims,nb=nb,ns=ns,nl=nl,wl=wl
  pos=indgen(nb)
  out_name=fileout

  ;大气校正
  envi_doit,'envi_quac_doit',$
    fid=fid,pos=pos,dims=dims,out_name=out_name,$
    r_fid=r_fid
  ;读取文件中数据

  ref = fltarr(ns, nl, nb);创建三维数组
  for  i=0,nb-1 do begin
    img=envi_get_data(fid=fid,dims=dims,pos=i)
    ref[*,*,i]=img
  endfor
  image=ref[*,*,[3,2,1]];xxxxxxxxxx
  image=congrid(image,350,340,3);调整大小
  widget_control,ev.top,get_uvalue=d
  wset,d
  tvscl,image,true=3;显示图像
  ;保存文件
  envi_write_envi_file,ref,out_name=fileout,wl=wl
  tmp=dialog_message('successful',/info)
end
'next':begin
  widget_control,ev.top,/destroy;打开新窗口
  fvc
end
endcase
end