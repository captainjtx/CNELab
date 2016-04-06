package src.java;
import javax.swing.JButton;
import javax.swing.border.EmptyBorder;
import javax.swing.ImageIcon;
import java.awt.Dimension;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import javax.swing.BorderFactory;
import java.awt.Color;


public class TButton extends JButton{
    
private ImageIcon icon;
private Color c;

public TButton(String pname,Dimension btn_d,String tip,Color bg)
{
    c=bg;
    setBorder(BorderFactory.createEmptyBorder());
    pname=pname.replace('\\', '/');
    
    icon = new ImageIcon(pname);
    setIcon(icon);
    setOpaque(true);
    setMinimumSize(btn_d);
    setMaximumSize(btn_d);
    setToolTipText(tip);
    setFocusable(false);
    addMouseListener(new MouseAdapter() {
        
//         boolean colourToggle = false;
        
        @Override
        public void mouseExited(MouseEvent e) {
            setBorder(BorderFactory.createEmptyBorder());
            setBackground(c);
        }
        
        @Override
        public void mouseEntered(MouseEvent e) {
            setBorder(BorderFactory.createMatteBorder(1,1,1,1,new Color(204,204,204)));
            setBackground(new Color(252,252,252));
        }
        
//         @Override
//         public void mouseClicked(MouseEvent e) {
//             if (colourToggle) {
//                 button.setBackground(new Color(100, 200, 100));
//             } else {
//                 button.setBackground(new Color(255, 0, 150));
//             }
//             colourToggle = !colourToggle;
//         }
    });
}
}