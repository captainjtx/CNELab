colergen = @(color,text) ['<html><table border=0 width=400 bgcolor=',color,'><TR><TD>',text,'</TD></TR> </table></html>'];
data = {  2.7183        , colergen(['rgb(' num2str([0 0 255]) ')'],'Red')
         'dummy text'   , colergen('rgb(0,255,0)','Green')
         3.1416         , colergen('rgb(0,0,255)','Blue')
         };
uitable('data',data)
