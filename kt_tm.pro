forward_function envi_get_data
forward_function ENVI_FILE_QUERY
pro KT_TM
  ;创建容器
  tlb=widget_base(xsize=750,ysize=320,title='KT_TM',tlb_frame_attr=1)
  ;显示容器
  widget_control,tlb,/realize
  ;容器中添加容器
  base1=widget_base(tlb,xsize=730,ysize=300,frame=1,xoffset=10,yoffset=5)

  ;容器中添加其他控件
  lab=widget_label(base1,value='Open Input File',xoffset=300,yoffset=20)
  lab=widget_label(base1,value='Open Output File',xoffset=300,yoffset=170)
  ;创建文本框

  testin1=widget_text(base1,xsize=40,ysize=1,xoffset=300,yoffset=40,uname='textin')
  testout=widget_text(base1,xsize=40,ysize=1,xoffset=300,yoffset=190,uname='textout')

  ;创建open按钮
  btnOpen1=widget_button(base1,value ='Open',xsize=70,ysize=25,xoffset=650,yoffset=40,uname ='buttonopen1')
  btnsave=widget_button(base1,value='save',xsize=70,ysize=25,xoffset=650,yoffset=190,uname='buttonsave')
  btnrun=widget_button(base1,value='run',xsize=70,ysize=25,xoffset=500,yoffset=270,uname='buttonrun')
  ;创建图像显示控件
  draw1=widget_draw(base1,xsize=280,ysize=290,xoffset=5,yoffset=5,uname='draw1')
  widget_control,draw1,get_value=win
  widget_control,tlb,set_uvalue=win
  ;在tlb的函数中添加事件获取语句
  xmanager,'KT_TM',tlb,/no_block
end

pro KT_TM_event,ev
  compile_opt idl2
  ;实现对文本框的编辑，获取文本框id
  textin1=widget_info(ev.top,find_by_uname='textin')
  textout=widget_info(ev.top,find_by_uname='textout')
  ;触发事件的控件uname
  uname=widget_info(ev.id,/uname)
  ;  widget_control,ev.top,get_uvalue=d
  case uname of
    'buttonopen1':begin
      envi,/restore_base_save_files
      envi_batch_init
      file1=dialog_pickfile(/read)
      widget_control,textin1,set_value=file1
      envi_open_file,file1,r_fid=fid
      if(fid eq -1) then return
      ENVI_FILE_QUERY, fid, DIMS=dims, NB=nb,ns=ns,nl=nl
      data=uintarr(ns,nl,nb)
      for  i=0,nb-1 do begin
        data=envi_get_data(fid=fid,dims=dims,pos=i)
        data=congrid(data,280,290,7)
        widget_control,ev.top,get_uvalue=win
        wset,win
        tvscl,data,/order
      endfor
    end
    'buttonsave':begin
      fileout=dialog_pickfile(/write)
      widget_control,textout,set_value=fileout
    end
    'buttonrun':begin
      envi,/restore_base_save_files
      envi_batch_init
      widget_control,textin1,get_value=file1
      widget_control, textout, get_value = fileOut  ;获取文本框内容
      envi_open_file,file1,r_fid=fid
      if(fid eq -1) then return
      ENVI_FILE_QUERY, fid, DIMS=dims, NB=nb,ns=ns,nl=nl
      data=uintarr(ns,nl,nb)
      for i=0,nb-1  do begin
        image=envi_get_data(fid=fid,dims=dims,pos=i)
        data[*,*,i]=image
      endfor
      B=0.3037*data[*,*,0]+0.2793*data[*,*,1]+0.4343*data[*,*,2]+0.5585*data[*,*,3]+0.5082*data[*,*,4]+0.1863*data[*,*,5]
      G=-0.2848*data[*,*,0]-0.2435*data[*,*,1]-0.5436*data[*,*,2]+0.7243*data[*,*,3]+0.0840*data[*,*,4]-0.1800*data[*,*,5]
      W=1509*data[*,*,0]+0.1793*data[*,*,1]+0.3299*data[*,*,2]+0.3406*data[*,*,3]-0.7112*data[*,*,4]-0.4572*data[*,*,5]
      
      
      data1=intarr(ns,nl,3)
      data1[*,*,0]=B
      data1[*,*,1]=G
      data1[*,*,2]=W    

      envi_write_envi_file,data1,out_name=fileout,nb=nb,ns=ns,nl=nl,wl=wl

      data1=congrid(data1,280,290,3)
      widget_control,ev.top,get_uvalue=win
      wset,win
      tvscl,data1,true=3
      tmp=dialog_message('successful',/info)
    end

  endcase
end