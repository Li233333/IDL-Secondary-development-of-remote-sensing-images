forward_function envi_get_data
forward_function ENVI_FILE_QUERY
pro KT_ETM
  ;创建容器
  tlb=widget_base(xsize=750,ysize=320,title='KT_ETM',tlb_frame_attr=1)
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
  xmanager,'KT_ETM',tlb,/no_block
end

pro KT_ETM_event,ev

  ;实现对文本框的编辑，获取文本框id
  compile_opt idl2
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
        data=congrid(data,280,290,6)
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
      ;file1=dialog_pickfile(/read)
      widget_control,textin1,get_value=file1
      widget_control, textout, get_value = fileOut  ;获取文本框内容
      envi_open_file,file1,r_fid=fid
      if(fid eq -1) then return
      ENVI_FILE_QUERY, fid, DIMS=dims, NB=nb,ns=ns,nl=nl
      data=dblarr(ns,nl,nb)
      for i=0,nb-1  do begin
        image=envi_get_data(fid=fid,dims=dims,pos=i)
        data[*,*,i]=image
      endfor
      B=0.3561*data[*,*,0]+0.3972*data[*,*,1]+0.3904*data[*,*,2]+0.6966*data[*,*,3]+0.2286*data[*,*,4]+0.1596*data[*,*,5]
      G=-0.3344*data[*,*,0]-0.3544*data[*,*,1]-0.4556*data[*,*,2]+0.6966*data[*,*,3]-0.0242*data[*,*,4]-0.2630*data[*,*,5]
      W=0.2626*data[*,*,0]+0.2141*data[*,*,1]+0.0926*data[*,*,2]+0.0656*data[*,*,3]-0.7629*data[*,*,4]-0.5388*data[*,*,5]
      Fourth=0.0805*data[*,*,0]-0.0498*data[*,*,1]+0.1950*data[*,*,2]-0.1327*data[*,*,3]+0.5752*data[*,*,4]-0.7775*data[*,*,5]
      Fifth=-0.7252*data[*,*,0]-0.0202*data[*,*,1]+0.6683*data[*,*,2]+0.0631*data[*,*,3]-0.1494*data[*,*,4]-0.0274*data[*,*,5]
      Sixth=0.4000*data[*,*,0]-0.8172*data[*,*,1]+0.3832*data[*,*,2]+0.0602*data[*,*,3]-0.1095*data[*,*,4]+0.0985*data[*,*,5]
      data1=dblarr(ns,nl,6)
      data1[*,*,0]=B
      data1[*,*,1]=G
      data1[*,*,2]=W
      data1[*,*,3]=Fourth
      data1[*,*,4]=Fifth
      data1[*,*,5]=Sixth
      envi_write_envi_file,data1,out_name=fileout,nb=nb,ns=ns,nl=nl,wl=wl
  
      data1=congrid(data1,280,290,6)
      widget_control,ev.top,get_uvalue=win
      wset,win
      tvscl,data1,true=3
      tmp=dialog_message('successful',/info)
    end

  endcase
end