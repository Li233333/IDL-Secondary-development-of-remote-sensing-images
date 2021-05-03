pro menutest
  base = widget_base( $
    xsize = 800, $
    ysize = 10, $
    tlb_frame_attr = 1, $
    title = 'SOUND GOOD NAME', $
    mbar = bar $  ;容器中添加主菜单，命名为bar
    )
  A1 = WIDGET_BUTTON( $  ;创建下拉菜单
    bar, $  ;声明下拉菜单所属的主菜单
    VALUE='preprocessing' ,$
    /MENU)
 
  
  B1 = WIDGET_BUTTON( $  ;创建下拉菜单
    A1, $  ;声明下拉菜单所属的主菜单
    VALUE='Radiometric Correction',/MENU)  ;菜单中的文字
  c1 = WIDGET_BUTTON(B1,VALUE='RCETM',uname='RCETM')
  c2 = WIDGET_BUTTON(B1,VALUE='RCTM',uname='RCTM')
  B2 = WIDGET_BUTTON(A1,VALUE='Quick Atmospheric Correction',uname='Quick Atmospheric Correction')  ;菜单项中的文字
  B3= WIDGET_BUTTON( $  ;创建下拉菜单
    A1, $  ;声明下拉菜单所属的主菜单
    VALUE='qutiaodai',/MENU)  ;菜单中的文字
    c1 = WIDGET_BUTTON(B3,VALUE='on-off',uname='on-off')
  c2 = WIDGET_BUTTON(B3,VALUE='off-off',uname='off-off')
  A2 = WIDGET_BUTTON( $  ;创建下拉菜单
    bar, $  ;声明下拉菜单所属的主菜单
    VALUE='Calculate Veg', $  ;菜单项中的文字
    /MENU)
  B1 = WIDGET_BUTTON( $  ;创建下拉菜单
    A2, $  ;声明下拉菜单所属的主菜单
    VALUE='NDVI', $  ;菜单项中的文字
    uname='NDVI')
  B2 = WIDGET_BUTTON( $  ;创建下拉菜单
    A2, $  ;声明下拉菜单所属的主菜单
    VALUE='FVC',uname='FVC')
  B3 = WIDGET_BUTTON( $  ;创建下拉菜单
    A2, $  ;声明下拉菜单所属的主菜单
    VALUE='Temperature', $  ;菜单项中的文字
    /MENU)

  C1 = WIDGET_BUTTON( $  ;创建下拉菜单
    B3, $  ;声明下拉菜单所属的主菜单
    VALUE='Radiation conductivity',uname='Radiation conductivity') ;菜单项中的文字

  C2 = WIDGET_BUTTON( $  ;创建下拉菜单
    B3, $  ;声明下拉菜单所属的主菜单
    VALUE='A mono-window algorithm',uname='A mono-window algorithm') ;菜单项中的文字

  C3 = WIDGET_BUTTON( $  ;创建下拉菜单
    B3, $  ;声明下拉菜单所属的主菜单
    VALUE='Single-channel method', $  ;菜单项中的文字
    /MENU)

  D1 = WIDGET_BUTTON( $  ;创建下拉菜单
    C3, $  ;声明下拉菜单所属的主菜单
    VALUE='OLI',$
    uname='oli')
  D2 = WIDGET_BUTTON( $  ;创建下拉菜单
    C3, $  ;声明下拉菜单所属的主菜单
    VALUE='TM',$
    uname='TM')
  D3 = WIDGET_BUTTON( $  ;创建下拉菜单
    C3, $  ;声明下拉菜单所属的主菜单
    VALUE='ETM+',$
    uname='ETM+')
  C4 = WIDGET_BUTTON( $  ;创建下拉菜单
    B3, $  ;声明下拉菜单所属的主菜单
    VALUE='Normalization Tem...',uname='Normalization Tem...')  ;菜单项中的文字

  C5 = WIDGET_BUTTON( $  ;创建下拉菜单
    B3, $  ;声明下拉菜单所属的主菜单
    VALUE='K-T',uname='K-T',/MENU);菜单项中的文字
  D1 = WIDGET_BUTTON( $  ;创建下拉菜单
    C5, $  ;声明下拉菜单所属的主菜单
    VALUE='k-t TM',uname='k-t TM')
  D2 = WIDGET_BUTTON( $  ;创建下拉菜单
    C5, $  ;声明下拉菜单所属的主菜单
    VALUE='k-t ETM',uname='k-t ETM')
  D3 = WIDGET_BUTTON( $  ;创建下拉菜单
    C5, $  ;声明下拉菜单所属的主菜单
    VALUE='k-t OLI',uname='k-t OLI')

  A4 = WIDGET_BUTTON( $  ;创建下拉菜单
    bar, $  ;声明下拉菜单所属的主菜单
    VALUE='Urban imoervous layer') ;菜单项中的文字
  B1 = WIDGET_BUTTON( $  ;创建下拉菜单
    A4, $  ;声明下拉菜单所属的主菜单
    VALUE='BCI',uname='BCI') ;菜单项中的文字
  A3 = WIDGET_BUTTON( $  ;创建下拉菜单
    bar, $  ;声明下拉菜单所属的主菜单
    VALUE='Change Detection', $  ;菜单项中的文字
    /MENU)
  B1 = WIDGET_BUTTON( $  ;创建下拉菜单
    A3, $  ;声明下拉菜单所属的主菜单
    VALUE='Change Detection...',uname='Change Detection...')
  WIDGET_CONTROL, base, /REALIZE
  xmanager, 'menutest', base, /no_block

end

pro menutest_event ,ev
  uname =widget_info(ev.id, /uname)
  case uname of
    'on-off':begin
      testwidget
    end
    'off-off':begin
      testwidget2
    end
    'RCETM':begin
      testRC
    end
    'RCTM':begin
      tm
    end
    'Quick Atmospheric Correction':begin
      testQC
    end
    'NDVI':begin
      Normalized_Difference_Vegetation_Index
    end
    'FVC':begin
      FVC
    end
    'Radiation conductivity':begin
     Radiation_conductivity 
    end
    'A mono-window algorithm':begin
      single_window
    end
    'TM':begin
      Single_Channel_TM
    end
    'oli':begin
      Single_Channel_OLI
    end
    'ETM+':begin
      Single_Channel_ETM
    end  
    'Normalization Tem...':begin
     test_TVDI
    end
    'k-t TM':begin
      KT_TM
    end
    'k-t ETM':begin
     KT_ETM
    end
    'k-t OLI':begin
     KT_OLI
    end
    'BCI':begin
     test_BCI
    end
    'Change Detection...':begin
     test_change
    end
  endcase
end
