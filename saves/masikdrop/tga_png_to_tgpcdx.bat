FOR %%A IN (*.png; *.tga) DO (
 rwacetool "%%A" 
 ConvertToTG.exe -i "%%~pA%%~nA.ace" -o "%%~pA%%~nA.tgpcdx"  -target pc  -forcecompress -interpalpha
)
