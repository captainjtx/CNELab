/*
Definitive Guide to Swing for Java 2, Second Edition
By John Zukowski
ISBN: 1-893115-78-X
Publisher: APress
 */
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.Font;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.awt.event.MouseEvent;

import java.util.EventObject;
import java.util.Vector;

import javax.swing.AbstractCellEditor;
import javax.swing.JCheckBox;

import javax.swing.JScrollPane;
import javax.swing.JTree;
import javax.swing.UIManager;
import javax.swing.event.ChangeEvent;
import javax.swing.tree.DefaultMutableTreeNode;
import javax.swing.tree.DefaultTreeCellRenderer;
import javax.swing.tree.DefaultTreeModel;
import javax.swing.tree.TreeCellEditor;
import javax.swing.tree.TreeCellRenderer;
import javax.swing.tree.TreePath;
import javax.swing.Icon;
import javax.swing.ImageIcon;

import java.io.File;
import java.lang.System;

public class CheckBoxNodeTree extends JScrollPane
{
    
    private JTree tree;
    
    class CheckBoxNode
    {
        String fullname;
        
        public String toString()
        {
            File f=new File(fullname);
            return f.getName();
        }
        
        public CheckBoxNode(String str)
        {
            fullname=str;
        }
    }
    public CheckBoxNodeTree() {
        tree = new JTree();
        tree.setRootVisible( false );
        tree.setShowsRootHandles(true);
        
        DefaultMutableTreeNode rootNode = new DefaultMutableTreeNode("Objects");
        DefaultTreeModel defaultTreeModel = new DefaultTreeModel( rootNode );
        
        tree.setModel( defaultTreeModel );
        
        DefaultMutableTreeNode parentNode = null;
        DefaultMutableTreeNode node = null;
        
        parentNode = (DefaultMutableTreeNode) defaultTreeModel.getRoot();
        node = new DefaultMutableTreeNode( new CheckBoxNode("Surface"));
        addNodeToDefaultTreeModel( defaultTreeModel, parentNode, node );
        
        parentNode = node;
        node = new DefaultMutableTreeNode( new CheckBoxNode("cortex.mat") );
        addNodeToDefaultTreeModel( defaultTreeModel, parentNode, node );
        
        parentNode = rootNode;
        node = new DefaultMutableTreeNode( new CheckBoxNode("Rendering"));
        addNodeToDefaultTreeModel( defaultTreeModel, parentNode, node );
        
        parentNode = (DefaultMutableTreeNode) defaultTreeModel.getRoot();
        node = new DefaultMutableTreeNode( new CheckBoxNode("Electrode"));
        addNodeToDefaultTreeModel( defaultTreeModel, parentNode, node );
        
        parentNode = rootNode;
        node = new DefaultMutableTreeNode( new CheckBoxNode("Others") );
        addNodeToDefaultTreeModel( defaultTreeModel, parentNode, node );
        
        // Set the icon for surface nodes.
        String surfaceIconFname="../../db/icon/surface.png";
        
        ImageIcon surfaceIcon = new ImageIcon(surfaceIconFname,"Surface Icon");
        if (surfaceIcon != null) {
            tree.setCellRenderer(new MyRenderer(surfaceIcon));
        } else {
            System.err.println("Surface icon missing; using default.");
        }
        
        setViewportView(tree);
    }
    private static void addNodeToDefaultTreeModel( DefaultTreeModel treeModel, DefaultMutableTreeNode parentNode, DefaultMutableTreeNode node )
    {
        treeModel.insertNodeInto(  node, parentNode, parentNode.getChildCount()  );
        
        if (  parentNode == treeModel.getRoot()  ) {
            treeModel.nodeStructureChanged(  (javax.swing.tree.TreeNode) treeModel.getRoot()  );
        }
    }
    
    private class MyRenderer extends DefaultTreeCellRenderer {
        Icon surfaceIcon;
        Icon electrodeIcon;
        Icon renderingIcon;
        Icon othersIcon;
        
        public MyRenderer(Icon icon) {
            surfaceIcon = icon;
        }
        
        public Component getTreeCellRendererComponent(JTree tree, Object value,
        boolean sel, boolean expanded, boolean leaf, int row, boolean hasFocus) {
            
            super.getTreeCellRendererComponent(tree, value, sel, expanded, leaf, row,
            hasFocus);
            if (!leaf && isSurface(value)) {
                setIcon(surfaceIcon);
                setToolTipText("Surface");
            } else {
                setToolTipText(null); // no tool tip
            }
            
            return this;
        }
        
        protected boolean isSurface(Object value) {
            DefaultMutableTreeNode node = (DefaultMutableTreeNode) value;
            CheckBoxNode nodeInfo = (CheckBoxNode) (node.getUserObject());
            String title = nodeInfo.fullname;
            if (title.indexOf("Surface") >= 0) {
                return true;
            }
            
            return false;
        }
    }
}
    
    
    
    
    
    
    
