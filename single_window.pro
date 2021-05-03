pro single_window

tlb = widget_base($
  xsize = 800,  $
  ysize = 400,  $
  tlb_frame_attr = 1, $
  title = 'single_window' )

btnRun = widget_button($
  tlb,$
  value = 'RUN', $
  xsize = 100,$
  ysize = 30, $
  xoffset = 600,$
  yoffset = 350 ,$
  uname='btnrun'$
  )

base1 = widget_base( $
  tlb, $
  xsize = 300, $
  ysize = 350, $
  xoffset = 25, $
  yoffset = 25, $
  frame= 1 $
  )
draw = widget_draw( $
  base1, $
  xsize = 280, $
  ysize = 340, $
  xoffset = 10, $
  yoffset = 5 ,$
  uname='draw'$

  )

base2 = widget_base( $
  tlb, $
  xsize = 425, $
  ysize = 320, $
  xoffset = 350, $
  yoffset = 25, $
  frame = 1 $
  )




labelIn2 = widget_label( $
  base2, $
  value = 't:', $
  xoffset = 30, $
  yoffset = 165 $
  )
textIn1 = widget_text( $
  base2, $
  xsize = 10, $
  ysize = 1, $
  xoffset = 75, $
  yoffset = 160, $
  uname ='textIn1' ,$
  /editable $

  )
labelIn3 = widget_label( $
  base2, $
  value = 'RH:', $
  xoffset = 250, $
  yoffset = 165 $
  )
textIn2 = widget_text( $
  base2, $
  xsize = 10, $
  ysize = 1, $
  xoffset = 300, $
  yoffset = 160, $
  uname ='textIn2', $
  /editable $
  )
labelIn5 = widget_label( $
  base2, $
  value = 'Open T6 File', $
  xoffset = 10, $
  yoffset = 10 $
  )
textIn4 = widget_text( $
  base2, $
  xsize = 50, $
  ysize = 1, $
  xoffset = 10, $
  yoffset = 25, $
  uname ='textIn4' $
  )
btnOpen1 = widget_button( $
  base2, $
  value = 'Open', $
  xsize = 70, $
  ysize = 25, $
  xoffset = 350, $
  yoffset = 25, $
  uname = 'buttonIn1' $
  )

labelIn6 = widget_label( $
  base2, $
  value = 'Open FLAASH File', $
  xoffset = 10, $
  yoffset = 75 $
  )
textIn5 = widget_text( $
  base2, $
  xsize = 50, $
  ysize = 1, $
  xoffset = 10, $
  yoffset = 90, $
  uname ='textIn5' $
  )
btnOpen2 = widget_button( $
  base2, $
  value = 'Open', $
  xsize = 70, $
  ysize = 25, $
  xoffset = 350, $
  yoffset = 90, $
  uname = 'buttonIn2' $
  )
labelIn7 = widget_label( $
  base2, $
  value = 'Open output File', $
  xoffset = 10, $
  yoffset = 265 $
  )
textout = widget_text( $
  base2, $
  xsize = 50, $
  ysize = 1, $
  xoffset = 10, $
  yoffset = 280, $
  uname ='textout' $
  )
btnOpen3 = widget_button( $
  base2, $
  value = 'Save', $
  xsize = 70, $
  ysize = 25, $
  xoffset = 350, $
  yoffset = 280, $
  uname = 'btsave' $
  )

widget_control, tlb, /realize
widget_control, draw, get_value = win
widget_control, tlb, set_uvalue = win
xmanager, 'single_window',tlb,/no_block
end


pro single_window_event, ev
  compile_opt idl2

  uname = widget_info(ev.id, /uname)  ;获取触发事件的控件的uname

  textIn  = widget_info(ev.top, find_by_uname = 'textIn');获取textIn控件的id
  textIn1 = widget_info(ev.top, find_by_uname = 'textIn1')
  textIn2 = widget_info(ev.top, find_by_uname = 'textIn2')
  textIn3 = widget_info(ev.top, find_by_uname = 'textIn3')
  textIn4 = widget_info(ev.top, find_by_uname = 'textIn4')
  textIn5 = widget_info(ev.top, find_by_uname = 'textIn5')
  textout = widget_info(ev.top, find_by_uname = 'textout')
  save  = widget_info(ev.top, find_by_uname = 'save')
  draw  = widget_info(ev.top,find_by_uname='draw')
  btnrun = widget_info(ev.top, find_by_uname = 'btnrun')
  sensor = widget_info(ev.top,find_by_uname='sensor')


  case uname of
    'buttonIn1' : begin
      envi,/restore_base_save_files
      envi_batch_init
      file1=dialog_pickfile()
      widget_control,textin4,set_value=file1
      envi_open_file,file1,R_FID=fid
      ENVI_FILE_QUERY, fid, dims=dims, nb=nb,ns=ns,nl=nl
      T6=uintarr(ns,nl)
      T6=envi_get_data(FID=fid,DIMS=dims,pos=0)
      data=congrid(T6,280,340)
      print,T6[1:10,1:10]
      widget_control,draw,get_value=win
      wset,win
      tvscl,data,/order

    end
    'buttonIn2':begin
    envi,/restore_base_save_files
    envi_batch_init
    file=dialog_pickfile()
    widget_control,textin5,set_value=file
    envi_open_file,file,r_fid=fid
    if(fid eq -1) then return
    ENVI_FILE_QUERY,fid,DIMS=dims, NB=nb,ns=ns,nl=nl,wl=wl
    data=uintarr(ns,nl,nb)
    for  i=0,nb-1 do begin
      img=envi_get_data(fid=fid,dims=dims,pos=i)
      data[*,*,i]=img
      image=data[*,*,[3,2,1]]
      image=congrid(image,280,340,3)
      print,image[1:10,1:10,0]
      widget_control,ev.top,get_uvalue=win
      wset,win
      tvscl,image,/order
    endfor
      end
    'btsave' : begin
      fileout = dialog_pickfile(/write)
      widget_control,textout,set_value=fileout ;修改文本框内容
    end
    'btnrun':begin
      widget_control,textin4,get_value=textin4
      widget_control,textin5,get_value=textin5
      widget_control,textout,get_value=fileout

      widget_control,  textIn1, get_value = t
      widget_control,  textIn2, get_value = RH
 

     
      envi_open_file,textin4,R_FID=fid
      ENVI_FILE_QUERY, fid, dims=dims, nb=nb,ns=ns,nl=nl
      T6=uintarr(ns,nl)
      T6=envi_get_data(FID=fid,DIMS=dims,pos=0)

   
  
     envi_open_file,textin5,r_fid=fid
     if(fid eq -1) then return
     ENVI_FILE_QUERY,fid,DIMS=dims, NB=nb,ns=ns,nl=nl,wl=wl
     data=uintarr(ns,nl,nb)
     for  i=0,nb-1 do begin
      img=envi_get_data(fid=fid,dims=dims,pos=i)
      data[*,*,i]=img
    endfor
    ndvi=(data[*,*,3]-data[*,*,2])*1.0/(data[*,*,3]+data[*,*,2])

    ndvi=(ndvi gt 1)*1+(ndvi lt -1)*(-1)+(ndvi le 1 and ndvi ge -1)*ndvi
    print,ndvi[1:10,1:10]
      t=t[0]
      RH=RH[0]
      help,t
      help,RH
  a=-67.355351
  b=0.458606
  Ta=16.0110+0.92621*(t+273.15)
  help,Ta
  w=0.0981*(6.1078*10^(7.5*t/(t+273.15)))*RH+0.1697
  help,w
  tao=0.974290-0.08007*w
  e=(ndvi le 0)*0.995+(ndvi gt 0 and ndvi le 0.157)*0.923+(ndvi gt 0.727)*0.986+(ndvi gt 0.157 and ndvi le 0.727)*(1.0094+0.047*alog(ndvi))
  C=e*tao
  D=(1-tao)*(1+(1*e)*tao)
  
  TS=(a*(1-C-D)+(b*(1-C-D)+C+D)*T6-D*Ta)/C
  TS=TS-273.15
      envi_write_envi_file,TS,out_name=fileOut,wl=wl
      tmp = dialog_message('successful!', /info)  ;显示提示框
    end
  endcase
end
