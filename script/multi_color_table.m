colergen = @(color,text) ['<html><table border=0 width=400 bgcolor=',color,'><TR><TD>',text,'</TD></TR> </table></html>'];
data = {  2.7183        , colergen('#FF0000','Red')
         'dummy text'   , colergen('#00FF00','Green')
         3.1416         , colergen('#0000FF','Blue')
         };
uitable('data',data)
