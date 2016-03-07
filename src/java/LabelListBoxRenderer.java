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
// import org.apache.commons.io.FilenameUtils;

// import globalVar;

public class LabelListBoxRenderer extends JLabel implements ListCellRenderer
{
	private String filename;
    private String filepath;
    
    private ImageIcon icon;
    
	private final Hashtable<String,ImageIcon> iconsCache = new Hashtable<String,ImageIcon>();
    

	// Class constructors
	public LabelListBoxRenderer() {
		setOpaque(true);
		setHorizontalAlignment(LEFT);
		setVerticalAlignment(CENTER);
//         System.out.print("Hello world");
	}
	public LabelListBoxRenderer(String filename,String filepath) {
		this();
		this.filename = filename;
        this.filepath = filepath;
        
        String iconFname = globalVar.CNELAB_PATH;
            
        iconFname=iconFname.concat("/db/icon/cds.png");
        iconFname=iconFname.replace('\\', '/');
        
        icon = getFileIcon(iconFname);
//         Image image = icon.getImage(); // transform it
//         Image newimg = image.getScaledInstance(20, 20,  java.awt.Image.SCALE_SMOOTH); // scale it the smooth way
//         this.icon = new ImageIcon(newimg);
	}

	// Return a label displaying both text and image.
	public Component getListCellRendererComponent(
			JList list,
			Object value,
			int index,
			boolean isSelected,
			boolean cellHasFocus)
	{
        String str=value.toString();
        File f=new File(str);
        
        Font test_font=new Font("TimesRoman", Font.PLAIN, 14);
		setFont(test_font);
        String label;
		if (isSelected) {
            // Selected cell item
			setBackground(list.getSelectionBackground());
            setForeground(list.getSelectionForeground());
            label="<html>"+"<font size=5 color=white>"+f.getName()+"</font>"+"<br>"+
            "<font size=4 color=white>"+str.substring(0, str.lastIndexOf(File.separator))+"</font>"+"</html>";
		} else {
			// Unselected cell item
            setBackground(list.getBackground());
            setForeground(list.getForeground());
            label="<html>"+"<font size=5 color=#434343>"+f.getName()+"</font>"+"<br>"+
            "<font size=4 color=#646464>"+str.substring(0, str.lastIndexOf(File.separator))+"</font>"+"</html>";
		}
        try {
			setIcon(icon);
		} catch (Exception e) {
			list.setToolTipText(e.getMessage());
		}
		//System.out.println(index + ": " + label);  // debug console printout
        
		setText(label);
        setBorder(new EmptyBorder(0,10,0,0));
        setIconTextGap(10);
		return this;
	}

	// Modify the folder path (default = current folder)
	public void setFilePath(String filepath) {
		this.filepath = filepath;
    }
    public void setFileName(String filename) {
        this.filename = filename;
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