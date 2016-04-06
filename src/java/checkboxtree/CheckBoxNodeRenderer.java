/*
 * #%L
 * Swing JTree check box nodes.
 * %%
 * Copyright (C) 2012 - 2015 Board of Regents of the University of
 * Wisconsin-Madison.
 * %%
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 * #L%
 */

package src.java.checkboxtree;

import java.awt.Color;
import java.awt.Component;
import java.awt.Font;

import javax.swing.JTree;
import javax.swing.UIManager;
import javax.swing.tree.DefaultMutableTreeNode;
import javax.swing.tree.DefaultTreeCellRenderer;
import javax.swing.tree.TreeCellRenderer;
import javax.swing.ImageIcon;

import java.io.File;

/**
 * A {@link TreeCellRenderer} for check box tree nodes.
 * <p>
 * Thanks to John Zukowski for the <a
 * href="http://www.java2s.com/Code/Java/Swing-JFC/CheckBoxNodeTreeSample.htm"
 * >sample code</a> upon which this is based.
 * </p>
 * 
 * @author Curtis Rueden
 */
public class CheckBoxNodeRenderer implements TreeCellRenderer {

	private final CheckBoxNodePanel panel = new CheckBoxNodePanel();

	private final DefaultTreeCellRenderer defaultRenderer =
		new DefaultTreeCellRenderer();

	private final Color selectionForeground, selectionBackground;
	private final Color textForeground, textBackground;

	protected CheckBoxNodePanel getPanel() {
		return panel;
	}
    
    private ImageIcon surfaceIcon;
    private ImageIcon electrodeIcon;
    private ImageIcon volumeIcon;
    private ImageIcon othersIcon;

	public CheckBoxNodeRenderer() {
		final Font fontValue = UIManager.getFont("Tree.font");
		if (fontValue != null) panel.label.setFont(fontValue);

		final Boolean focusPainted =
			(Boolean) UIManager.get("Tree.drawsFocusBorderAroundIcon");
		panel.check.setFocusPainted(focusPainted != null && focusPainted);

		selectionForeground = UIManager.getColor("Tree.selectionForeground");
		selectionBackground = UIManager.getColor("Tree.selectionBackground");
		textForeground = UIManager.getColor("Tree.textForeground");
		textBackground = UIManager.getColor("Tree.textBackground");
        
        final File f = new File(CheckBoxNodeRenderer.class.getProtectionDomain().getCodeSource().getLocation().getPath());
//         System.out.print(f.toString());
        
        String surfaceIconFname=f.toString()+"/db/icon/surface.png";
        surfaceIcon = new ImageIcon(surfaceIconFname,"Surface Icon");
        
        String electrodeIconFname=f.toString()+"/db/icon/ecog.png";
        electrodeIcon = new ImageIcon(electrodeIconFname,"Electrode Icon");
        
        String volumeIconFname=f.toString()+"/db/icon/volume.png";
        volumeIcon = new ImageIcon(volumeIconFname,"Volume Icon");
        
        String othersIconFname=f.toString()+"/db/icon/others.png";
        othersIcon = new ImageIcon(othersIconFname,"Others Icon");
	}

	// -- TreeCellRenderer methods --

	@Override
	public Component getTreeCellRendererComponent(final JTree tree,
		final Object value, final boolean selected, final boolean expanded,
		final boolean leaf, final int row, final boolean hasFocus)
	{
		CheckBoxNodeData data = null;
		if (value instanceof DefaultMutableTreeNode) {
			final DefaultMutableTreeNode node = (DefaultMutableTreeNode) value;
			final Object userObject = node.getUserObject();
			if (userObject instanceof CheckBoxNodeData) {
				data = (CheckBoxNodeData) userObject;
			}
		}

		final String stringValue =
			tree.convertValueToText(value, selected, expanded, leaf, row, false);
		panel.label.setText(stringValue);
		panel.check.setSelected(false);

		panel.setEnabled(tree.isEnabled());
        

		if (selected) {
			panel.setForeground(selectionForeground);
			panel.setBackground(selectionBackground);
			panel.label.setForeground(selectionForeground);
			panel.label.setBackground(selectionBackground);
		}
		else {
			panel.setForeground(textForeground);
			panel.setBackground(textBackground);
			panel.label.setForeground(textForeground);
			panel.label.setBackground(textBackground);
		}

		if (data == null) {
			// not a check box node; return default cell renderer
            
            defaultRenderer.setText(stringValue);
                
            if (isSurface(value))
            {
                defaultRenderer.setIcon(surfaceIcon);
                defaultRenderer.setToolTipText("Surface");
            }
            else if (isElectrode(value))
            {
                defaultRenderer.setIcon(electrodeIcon);
                defaultRenderer.setToolTipText("Electrode");
            }
            else if (isVolume(value))
            {
                defaultRenderer.setIcon(volumeIcon);
                defaultRenderer.setToolTipText("Volume");
            }

            else
            {
                defaultRenderer.setIcon(othersIcon);
                defaultRenderer.setToolTipText("Others");
            }

			return (Component) defaultRenderer;
            
		}

		panel.label.setText(data.toString());
//         panel.label.setIcon(surfaceIcon);
		panel.check.setSelected(data.isChecked());

		return panel;
	}
    protected boolean isSurface(Object value)
    {
        DefaultMutableTreeNode node = (DefaultMutableTreeNode) value;
        String title = node.toString();
        
        if (title.indexOf("Surface") >= 0) {
            return true;
        }
        return false;
    }
    protected boolean isElectrode(Object value)
    {
        DefaultMutableTreeNode node = (DefaultMutableTreeNode) value;
        String title = node.toString();
        
        if (title.indexOf("Electrode") >= 0) {
            return true;
        }
        return false;
    }
        protected boolean isVolume(Object value)
    {
        DefaultMutableTreeNode node = (DefaultMutableTreeNode) value;
        String title = node.toString();
        
        if (title.indexOf("Volume") >= 0) {
            return true;
        }
        return false;
    }

}
