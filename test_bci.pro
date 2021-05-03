pro test_BCI
tlb=widget_base(xsize=800,ysize=400,tlb_frame_attr=1,title='BCI calculate')

button=widget_button(tlb,value='OK',$
  xsize=100,$
  ysize=30,$
  xoffset=600,$
  yoffset=350,$
  uname='Ok')

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


labelIn = widget_label( $  ;创建文字控件
  base2, $  ;添加至base2
  value = 'Open Input File', $  ;文字内容
  xoffset = 10, $  ;横向位置
  yoffset = 10 $  ;纵向位置
  )

textIn = widget_text( $
  base2, $
  xsize = 40, $
  ysize = 1, $
  xoffset = 10, $
  yoffset = 25, $
  uname = 'textIn' $  ;设置uname
  )

btnOpen = widget_button( $
  base2, $
  value = 'Open', $
  xsize = 70, $
  ysize = 25, $
  xoffset = 350, $
  yoffset = 25, $
  uname = 'buttonIn' $  ;设置uname
  )


labelOut = widget_label( $  ;创建文字控件
  base2, $  ;添加至base2
  value = 'Output File', $  ;文字内容
  xoffset = 10, $  ;横向位置
  yoffset = 110 $  ;纵向位置
  )

textIn1 = widget_text( $
  base2, $
  xsize = 40, $
  ysize = 1, $
  xoffset = 10, $
  yoffset = 125, $
  uname = 'textSave' $  ;设置uname
  )

btnsave = widget_button( $
  base2, $
  value = 'Save', $
  xsize = 70, $
  ysize = 25, $
  xoffset = 350, $
  yoffset = 125, $
  uname = 'buttonSave' $  ;设置uname
  )

widget_control,tlb,/realize
widget_control, draw, get_value = d  ;获取图像控件的窗口ID
widget_control, tlb, set_uvalue = d  ;保存图像控件的窗口ID
xmanager, 'test_BCI', tlb, /no_block
end




pro test_BCI_event, ev
  
  ;获取textIn、textSave控件的id
  compile_opt idl2
  textIn = widget_info(ev.top, find_by_uname = 'textIn')
  textSave = widget_info(ev.top, find_by_uname = 'textSave')
  uname = widget_info(ev.id, /uname)  ;获取触发事件的控件的uname
  case uname of
    'buttonIn' : begin  ;如果点击Open按钮，则执行以下操作
    envi,/restore_base_save_files
    envi_batch_init
    file=dialog_pickfile()
    widget_control,textin,set_value=file
    envi_open_file,file,r_fid=fid
    if(fid eq -1) then return
    ENVI_FILE_QUERY,fid,DIMS=dims, NB=nb,ns=ns,nl=nl,wl=wl
    data=dblarr(ns,nl,nb)
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
      'buttonSave' : begin  ;如果点击Save按钮，则执行以下操作
        fileOut = dialog_pickfile(/write)  ;保存文件对话框
        widget_control, textSave, set_value = fileOut  ;修改文本框内容
      end
      'Ok' : begin  
        widget_control,textin,get_value=file
        widget_control,textSave,get_value=fileout
        envi,/restore_base_save_files
        envi_batch_init
        envi_open_file,file,r_fid=fid
        ENVI_FILE_QUERY, fid, DIMS=dims, nb=nb,ns=ns,nl=nl,wl=wl
        data=dblarr(ns,nl,nb)       
       for  k=0,nb-1 do begin
       img=ENVI_GET_DATA(fid=fid,dims=dims,pos=k)
       data[*,*,k]=img
       endfor
      ;计算水体指数
       data1=(data[*,*,1]-data[*,*,3])/(data[*,*,1]+data[*,*,3])
       idx1=where(data1 ge 0 ,complement=idx2)
       data1[idx1]=0
       data1[idx2]=1
       ;掩膜水体
      data2=dblarr(ns,nl,nb)
       for i = 0,nb-1 do begin
      temp1=data[*, *, i]*data1
      data2[*,*,i]=temp1
       endfor
      ;计算BCI
      BCI=((data2[*,*,0]+data2[*,*,2])/2-data2[*,*,1])/((data2[*,*,0]+data2[*,*,2])/2+data2[*,*,1])
      BCI=congrid(BCI,280,340)
       widget_control,ev.top,get_uvalue=d
       wset,d
       tvscl,BCI
       BCI=BCI>(0)
       BCI=BCI<(1);BCI值归一化
       envi_write_envi_file,bci,out_name=fileout,wl=wl
       tmp=dialog_message('successful',/info)
      end
  endcase
end