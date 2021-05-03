pro Radiation_conductivity
;容器
tlb = widget_base($
    xsize = 800,  $
    ysize = 400,  $
    tlb_frame_attr = 1, $
    title = 'Radiation conductivity' )
    
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
  
  labelIn1 = widget_label( $ 
    base2, $  
    value = 'Sensortype:', $ 
    xoffset = 5, $  
    yoffset = 165 $ 
    )      
  sensor = widget_droplist( $  
    base2, $  
    value=['TM','ETM+','OLI'],$
    xsize = 75, $ 
    ysize = 20, $  
    xoffset = 75, $
    yoffset = 160 , $
    uname ='sensor' $
    )
 
  labelIn2 = widget_label( $
    base2, $
    value = 'T:', $
    xoffset = 30, $
    yoffset = 195 $
    )
  textIn1 = widget_text( $
    base2, $
    xsize = 10, $
    ysize = 1, $
    xoffset = 75, $
    yoffset = 190, $
    uname ='textIn1' ,$
    /editable $
    
    )
  labelIn3 = widget_label( $
    base2, $
    value = 'L_up:', $
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

    
  labelIn4 = widget_label( $
    base2, $
    value = 'L_down:', $
    xoffset = 250, $
    yoffset = 200 $
    )
  textIn3 = widget_text( $
    base2, $
    xsize = 10, $
    ysize = 1, $
    xoffset = 300, $
    yoffset = 195, $
    uname ='textIn3' ,$
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
    value = 'Open FVC File', $
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
  xmanager, 'Radiation_conductivity',tlb,/no_block
end


pro Radiation_conductivity_event, ev
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
    'buttonIn1' : begin  ;设置按钮响应事件
    envi,/restore_base_save_files ;调用envi里的函数读取文件
     envi_batch_init
     file1=dialog_pickfile()   
    widget_control,textin4,set_value=file1  ;将文件目录读取后存储在相应的文本框里
    envi_open_file,file1,R_FID=fid        ;打开目录里的T6单波段文件
    ENVI_FILE_QUERY, fid, dims=dims, nb=nb,ns=ns,nl=nl
    L=uintarr(ns,nl)
    L=envi_get_data(FID=fid,DIMS=dims,pos=0)
     data=congrid(L,280,340) 
     print,L[1:10,1:10]               ;输出一部分数据用于验证数据内容的对错
     widget_control,draw,get_value=win    ;将数据显示在
     wset,win
     tvscl,data,/order 
   
    end
   'buttonIn2':begin
      envi,/restore_base_save_files
      envi_batch_init
      file2=dialog_pickfile()
      widget_control,textin5,set_value=file2
      envi_open_file,file2,R_FID=fid
      ENVI_FILE_QUERY, fid, dims=dims, nb=nb,ns=ns,nl=nl
      FV=uintarr(ns,nl)
      FV=envi_get_data(FID=fid,DIMS=dims,POS=0)
      data1=congrid(FV,280,340)
      print,fv[1:10,1:10]
      widget_control,draw,get_value=win
      wset,win
      tvscl,data1,/order
      end
      'btsave' : begin
      fileout = dialog_pickfile(/write)
      widget_control,textout,set_value=fileout ;修改文本框内容
      end
      'btnrun':begin
        widget_control,textin4,get_value=textin4
        widget_control,textin5,get_value=textin5
        widget_control,textout,get_value=fileout
        
        widget_control,  textIn1, get_value = a
        widget_control,  textIn2, get_value = b
        widget_control,  textIn3, get_value = c  
         

        envi_open_file,textin4,R_FID=fid
        ENVI_FILE_QUERY, fid, dims=dims, nb=nb,ns=ns,nl=nl
        L=uintarr(ns,nl)
        L=envi_get_data(FID=fid,DIMS=dims,pos=0)


        envi_open_file,textin5,R_FID=fid
        ENVI_FILE_QUERY, fid, dims=dims, nb=nb,ns=ns,nl=nl
        FV=uintarr(ns,nl)
        FV=envi_get_data(FID=fid,DIMS=dims,POS=0)
  
         
         e=FV*0.004+0.986
         a=a[0]
         b=b[0]
         c=c[0]
         print,a
         print,b
         print,c

  
         BTS=(L-b-a*(1-e)*c)/(a*e)
      
         index = widget_info(sensor, /droplist_select)
         KK=[[607.76,1260.56],[666.09,1282.71],[774.89,1321.08]]
         case index of
           0:k=kk[*,0]
           1:k=kk[*,1]
           2:k=kk[*,2]
           end
         TS=K[1]/alog(k[0]/BTS+1)
         TS=TS-273.15
         envi_write_envi_file,Ts,out_name=fileOut,wl=wl
         print,k
         tmp = dialog_message('successful!', /info)  ;显示提示框
        end
endcase
end