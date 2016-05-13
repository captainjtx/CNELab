package src.java;
import javax.swing.JToggleButton;
import javax.swing.border.EmptyBorder;
import javax.swing.ImageIcon;
import java.awt.Dimension;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import javax.swing.BorderFactory;
import java.awt.Color;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;


public class TogButton extends JToggleButton{
    
    private ImageIcon icon;
    private Color c;
    
    public TogButton(String pname,Dimension btn_d,String tip,Color bg)
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
                if (!isSelected())
                {
                    setBorder(BorderFactory.createEmptyBorder());
                }
                setBackground(c);
            }
            
            @Override
            public void mouseEntered(MouseEvent e) {
                if (!isSelected())
                {
                    setBorder(BorderFactory.createMatteBorder(1,1,1,1,new Color(204,204,204)));
                }
                setBackground(new Color(252,252,252));
            }
        });
        ItemListener itemListener = new ItemListener() {
            public void itemStateChanged(ItemEvent itemEvent) {
                int state = itemEvent.getStateChange();
                if (state == ItemEvent.SELECTED) {
                    setBorder(BorderFactory.createLoweredBevelBorder());
                } else {
                    setBorder(BorderFactory.createEmptyBorder());
                }
            }
        };
        // Attach Listeners
        addItemListener(itemListener);
    }
}