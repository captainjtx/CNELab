import java.awt.Color;
import java.awt.Component;
import java.awt.Font;
import java.util.Hashtable;

import javax.swing.ImageIcon;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.ListCellRenderer;
import java.io.File;
import java.lang.System;

import java.awt.Image;
import javax.swing.border.EmptyBorder;
import java.io.File;
import java.awt.Dimension;
// import org.apache.commons.io.FilenameUtils;

// import globalVar;

public class LabelListBoxRenderer extends JLabel implements ListCellRenderer
{
    
    private ImageIcon cds_icon;
    private ImageIcon noncds_icon;
    
    private int[] FileType;
    
	private final Hashtable<String,ImageIcon> iconsCache = new Hashtable<String,ImageIcon>();
    

	// Class constructors
	public LabelListBoxRenderer() {
		setOpaque(true);
		setHorizontalAlignment(LEFT);
        setVerticalAlignment(CENTER);
        
        String cdsIconFname="../../db/icon/cds.png";
        
        cds_icon = getFileIcon(cdsIconFname);
        
        String noncdsIconFname="../../db/icon/noncds.png";
        
        noncds_icon=getFileIcon(noncdsIconFname);
//         System.out.print("Hello world");
	}

	// Return a label displaying both text and image.
	public Component getListCellRendererComponent(
			JList list,
			Object value,
			int index,
			boolean isSelected,
			boolean cellHasFocus)
	{
//         Dimension d=getSize();
//         d.width=list.getWidth();
//         setPreferredSize(d);
        
        String str=value.toString();
        
        File f=new File(str);
        
//         Font test_font=new Font("TimesRoman", Font.PLAIN, 14);
// 		setFont(test_font);
        String label;
        String path_str;
        String name_str;
        if (str.lastIndexOf(File.separator)==-1)
        {
            path_str="";
            name_str=str;
        }
        else
        {
            path_str=str.substring(0,str.lastIndexOf(File.separator));
            name_str=f.getName();
        }
        
		if (isSelected) {
            // Selected cell item
			setBackground(list.getSelectionBackground());
//             setForeground(list.getSelectionForeground());
            label="<html>"+"<div style=\"color:white; width:200px; font-size:8px \">"+name_str+"</div>"+
            "<div style=\"color:white; width:2000px; font-size:7px \">"+path_str+"</div>"+"</html>";
		} else {
			// Unselected cell item
            setBackground(list.getBackground());
//             setForeground(list.getForeground());
            label="<html>"+"<div style=\"color:#232323; width:200px; font-size:8px \">"+name_str+"</div>"+
            "<div style=\"color:#545454; width:200px; font-size:7px \">"+path_str+"</div>"+"</html>";
		}
        try {
            if(FileType[index]==1)
            {
                setIcon(cds_icon);
            }
            else if (FileType[index]==-1)
            {setIcon(noncds_icon);}
            
		} catch (Exception e) {
			list.setToolTipText(e.getMessage());
		}
		//System.out.println(index + ": " + label);  // debug console printout
        
		setText(label);
        setBorder(new EmptyBorder(0,10,0,0));
        setIconTextGap(10);
		return this;
	}
    
    public void setFileType(int[] ft)
    {
        FileType=ft;
    }

	// Lazily load the file icons only as needed, later reuse cached data
	private ImageIcon getFileIcon(String filename) {
		ImageIcon icon;
		if (iconsCache.containsKey(filename)) {
			// Reuse cached data
			icon = iconsCache.get(filename);
		} else {
			// Lazily load the file icons only as needed
			icon = new ImageIcon(filename);
			iconsCache.put(filename, icon);  // store in cache for later use
		}
		return icon;
	}
}