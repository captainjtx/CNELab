package src.java.checkboxtree;

import java.awt.BorderLayout;

import javax.swing.JFrame;
import javax.swing.JScrollPane;
import javax.swing.JTree;
import javax.swing.event.TreeModelEvent;
import javax.swing.event.TreeModelListener;
import javax.swing.event.TreeSelectionEvent;
import javax.swing.event.TreeSelectionListener;
import javax.swing.tree.DefaultMutableTreeNode;
import javax.swing.tree.DefaultTreeModel;

import javax.swing.ImageIcon;

import java.util.ArrayList;

import java.awt.BorderLayout;
import java.awt.Insets;

import javax.swing.JCheckBox;
import javax.swing.JLabel;
import javax.swing.JPanel;

import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;
import java.awt.event.ItemListener;
import java.awt.event.ItemEvent;

import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;

import javax.swing.AbstractButton;
import javax.swing.ButtonModel;

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

import java.awt.Component;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.awt.event.MouseEvent;
import java.util.EventObject;

import javax.swing.AbstractCellEditor;
import javax.swing.JTree;
import javax.swing.tree.DefaultMutableTreeNode;
import javax.swing.tree.TreeCellEditor;
import javax.swing.tree.TreePath;

import java.util.Hashtable;


public class FileLoadTree
{
    public JTree tree;
    
    public JScrollPane span;
    
    private int SurfaceID=0;
    private int ElectrodeID=0;
    private int VolumeID=0;
    private int OthersID=0;
    
    private DefaultMutableTreeNode SurfaceNode = null;
    private DefaultMutableTreeNode ElectrodeNode = null;
    private DefaultMutableTreeNode VolumeNode = null;
    private DefaultMutableTreeNode OthersNode = null;
    private DefaultTreeModel defaultTreeModel;
    
    public JScrollPane buildfig()
    {
        tree=new JTree();
        
        tree.setRootVisible( false );
        tree.setShowsRootHandles(true);
        
        DefaultMutableTreeNode rootNode = new DefaultMutableTreeNode("Objects");
        defaultTreeModel = new DefaultTreeModel( rootNode );
        
        tree.setModel( defaultTreeModel );
        
        DefaultMutableTreeNode parentNode = null;
        DefaultMutableTreeNode node = null;
        
        parentNode = rootNode;
        node = new DefaultMutableTreeNode( new DefaultMutableTreeNode("Volume"));
        addNodeToDefaultTreeModel( defaultTreeModel, parentNode, node );
        
        VolumeNode=node;
        
        parentNode = (DefaultMutableTreeNode) defaultTreeModel.getRoot();
        node = new DefaultMutableTreeNode( new DefaultMutableTreeNode("Surface"));
        addNodeToDefaultTreeModel( defaultTreeModel, parentNode, node );
        
        SurfaceNode=node;
        
        parentNode = (DefaultMutableTreeNode) defaultTreeModel.getRoot();
        node = new DefaultMutableTreeNode( new DefaultMutableTreeNode("Electrode"));
        addNodeToDefaultTreeModel( defaultTreeModel, parentNode, node );
        
        ElectrodeNode=node;
        
        parentNode = rootNode;
        node = new DefaultMutableTreeNode( new DefaultMutableTreeNode("Others") );
        addNodeToDefaultTreeModel( defaultTreeModel, parentNode, node );
        
        OthersNode=node;
        
        CheckBoxNodeRenderer renderer=new CheckBoxNodeRenderer();
        tree.setCellRenderer(new CheckBoxNodeRenderer());
        
        final CheckBoxNodeEditor editor = new CheckBoxNodeEditor(tree);
        tree.setCellEditor(editor);
        tree.setEditable(true);
        
//         tree.setSelectionRow(0);
        
        tree.addTreeSelectionListener( new TreeSelectionListener()
        {
            @Override
            public void valueChanged(TreeSelectionEvent e)
            {
                CheckBoxNodeData data = null;
                
                DefaultMutableTreeNode node= (DefaultMutableTreeNode) tree.getLastSelectedPathComponent();
                
                if (node == null) return;
                
                
                Object nodeInfo=node.getUserObject();
                if (nodeInfo instanceof CheckBoxNodeData)
                {
                    data = (CheckBoxNodeData) nodeInfo;
                }
                
//                 TreePath currentPath=tree.getSelectionPath();
//                 TreePath parentPath=currentPath.getParentPath();
//                 int num=tree.getRowForPath(currentPath)-tree.getRowForPath(parentPath);
                
                if (data!=null)
                {
                    //subnode
                    notifyTreeSelection(data.getText(),data.isChecked(),node.getParent().toString(),node.getLevel(),data.getID());
                }
                else
                {
                    //mainnode
                    notifyTreeSelection(node.toString(),true,node.toString(),node.getLevel(),0);
                }
            }
        });
        
        // listen for changes in the model (including check box toggles)
//         defaultTreeModel.addTreeModelListener(new TreeModelListener() {
//
//             @Override
//             public void treeNodesChanged(final TreeModelEvent e) {
// //                 System.out.println(System.currentTimeMillis() + ": nodes changed");
//             }
//
//             @Override
//             public void treeNodesInserted(final TreeModelEvent e) {
// //                 System.out.println(System.currentTimeMillis() + ": nodes inserted");
//             }
//
//             @Override
//             public void treeNodesRemoved(final TreeModelEvent e) {
// //                 System.out.println(System.currentTimeMillis() + ": nodes removed");
//             }
//
//             @Override
//             public void treeStructureChanged(final TreeModelEvent e) {
// //                 System.out.println(System.currentTimeMillis() + ": structure changed");
//             }
//         });
//         tree.setFocusable(false);
        
        span=new JScrollPane(tree);
        span.setViewportView(tree);
        
//         span.setFocusable(false);
        
        return span;
    }
    private DefaultMutableTreeNode add(final DefaultMutableTreeNode parent, final String text,final boolean checked, final int id)
    {
        CheckBoxNodeData data = new CheckBoxNodeData(text, checked,id);
        DefaultMutableTreeNode node = new DefaultMutableTreeNode(data);
        parent.add(node);
        return node;
    }
    private static void addNodeToDefaultTreeModel( DefaultTreeModel treeModel, DefaultMutableTreeNode parentNode, DefaultMutableTreeNode node )
    {
        treeModel.insertNodeInto(  node, parentNode, parentNode.getChildCount()  );
        
        if (  parentNode == treeModel.getRoot()  ) {
            treeModel.nodeStructureChanged(  (javax.swing.tree.TreeNode) treeModel.getRoot()  );
        }
    }
    private final Hashtable<String,CheckBoxNodeData> nodeCache = new Hashtable<String,CheckBoxNodeData>();
    
    public int addSurface(String filename, boolean chk)
    {
            CheckBoxNodeData dat=new CheckBoxNodeData(filename,chk,++SurfaceID);
            DefaultMutableTreeNode node = new DefaultMutableTreeNode( dat );
            addNodeToDefaultTreeModel( defaultTreeModel, SurfaceNode, node );
//             expandAllNodes(tree, 0, tree.getRowCount());
            
            TreePath newPath=new TreePath(defaultTreeModel.getPathToRoot(node));
            tree.scrollPathToVisible(newPath);
            tree.setSelectionPath(newPath);
            
//             TreePath parentPath= new TreePath(defaultTreeModel.getPathToRoot(SurfaceNode));
//             int num=tree.getRowForPath(newPath)-tree.getRowForPath(parentPath);
            
            nodeCache.put("surface"+SurfaceID,dat);
            
            return SurfaceID;
    }
    public int addVolume(String filename, boolean chk)
    {
            CheckBoxNodeData dat=new CheckBoxNodeData(filename,chk,++VolumeID);

            
            DefaultMutableTreeNode node = new DefaultMutableTreeNode( dat );
            addNodeToDefaultTreeModel( defaultTreeModel, VolumeNode, node );
//             expandAllNodes(tree, 0, tree.getRowCount());
            TreePath newPath=new TreePath(defaultTreeModel.getPathToRoot(node));
            tree.scrollPathToVisible(newPath);
            tree.setSelectionPath(newPath);
            
            nodeCache.put("volume"+VolumeID,dat);
            
            return VolumeID;
    }
    public int addElectrode(String filename, boolean chk)
    {
            CheckBoxNodeData dat=new CheckBoxNodeData(filename,chk,++ElectrodeID);
            
            DefaultMutableTreeNode node = new DefaultMutableTreeNode( dat );
            addNodeToDefaultTreeModel( defaultTreeModel, ElectrodeNode, node );
//             expandAllNodes(tree, 0, tree.getRowCount());
            
            TreePath newPath=new TreePath(defaultTreeModel.getPathToRoot(node));
            tree.scrollPathToVisible(newPath);
            tree.setSelectionPath(newPath);
            
            nodeCache.put("electrode"+ElectrodeID,dat);
            return ElectrodeID;
            
    }
    public int addOthers(String filename, boolean chk)
    {
            CheckBoxNodeData dat=new CheckBoxNodeData(filename,chk,++OthersID);
            
            DefaultMutableTreeNode node = new DefaultMutableTreeNode( dat );
            addNodeToDefaultTreeModel( defaultTreeModel, OthersNode, node );
//             expandAllNodes(tree, 0, tree.getRowCount());
            TreePath newPath=new TreePath(defaultTreeModel.getPathToRoot(node));
            tree.scrollPathToVisible(newPath);
            tree.setSelectionPath(newPath);
            nodeCache.put("others"+OthersID,dat);
            return OthersID;
    }
    
    public ArrayList<TreeListener> treelistener = new ArrayList<>();
    
    public synchronized void addTreeListener(TreeListener lis) {
//         System.out.println("hello");
        treelistener.add(lis);
    }
    public synchronized void removeTreeListener(TreeListener lis) {
        treelistener.remove(lis);
    }
    public interface TreeListener extends java.util.EventListener {
        void treeSelection(TreeEvent event);
    }
    public class TreeEvent extends java.util.EventObject {
        public String filename;
        public boolean ischecked;
        public String category;
        public int level;
        public int ind;
        public String getKey()
        {
            return category+ind;
        }
        
        public TreeEvent(Object source, String filename, boolean ischecked, String category, int level, int ind)
        {
            super(source);
            this.filename=filename;
            this.ischecked=ischecked;
            this.category=category;
            this.level=level;
            this.ind=ind;
        }
    }
    public void notifyTreeSelection(String filename,boolean ischecked,String category,int level,int ind) {
        for(TreeListener obj : treelistener)
        {
            obj.treeSelection(new TreeEvent(this,filename,ischecked,category,level,ind));
        }
    }
    public ArrayList<CheckListener> checklistener = new ArrayList<>();
    
    public synchronized void addCheckListener(CheckListener lis) {
//         System.out.println("hello");
        checklistener.add(lis);
    }
    public synchronized void removeCheckListener(CheckListener lis) {
        checklistener.remove(lis);
    }
    public interface CheckListener extends java.util.EventListener {
        void checkChanged(TreeEvent event);
    }

    public void notifyCheckChange(String filename,boolean ischecked,String category,int level,int ind) {
        for(CheckListener obj : checklistener)
        {
            obj.checkChanged(new TreeEvent(this,filename,ischecked,category,level,ind));
        }
    }
    
    public class CheckBoxNodePanel extends JPanel {
        
        private final JLabel label = new JLabel();
        private final JCheckBox check = new JCheckBox();
        private ActionListener actionListener;
        
        public CheckBoxNodePanel() {
            actionListener = new ActionListener() {
                public void actionPerformed(ActionEvent actionEvent) {
//                     AbstractButton abstractButton = (AbstractButton) actionEvent
//                     .getSource();
//                     boolean selected = abstractButton.getModel().isSelected();
                    CheckBoxNodeData data = null;
                    
                    DefaultMutableTreeNode node= (DefaultMutableTreeNode) tree.getLastSelectedPathComponent();
                    
                    if (node == null) return;
                    
                    Object nodeInfo=node.getUserObject();
                    
                    if (nodeInfo instanceof CheckBoxNodeData)
                    {
                        data = (CheckBoxNodeData) nodeInfo;
                    }
                    
                    if (data!=null)
                    {
                        TreePath currentPath=new TreePath(defaultTreeModel.getPathToRoot(node));
                        TreePath parentPath=currentPath.getParentPath();
                        int num=tree.getRowForPath(currentPath)-tree.getRowForPath(parentPath);
                        notifyCheckChange(data.getText(),data.isChecked(),node.getParent().toString(),node.getLevel(),num);
                    }
                }
            };
            
            this.check.addActionListener(actionListener);
            
            this.check.setMargin(new Insets(0, 0, 0, 0));
            setLayout(new BorderLayout());
            add(check, BorderLayout.WEST);
            add(label, BorderLayout.CENTER);
        }
        
    }
    
    public class CheckBoxNodeRenderer implements TreeCellRenderer {
        
        private final CheckBoxNodePanel panel = new CheckBoxNodePanel();
        
        private final CheckBoxNodeData nodedata = new CheckBoxNodeData("",false,0);
        
        private final DefaultTreeCellRenderer defaultRenderer =
        new DefaultTreeCellRenderer();
        
        private final Color selectionForeground, selectionBackground;
        private final Color textForeground, textBackground;
        
        protected CheckBoxNodePanel getPanel() {
            return panel;
        }
        protected CheckBoxNodeData getNodeData() {
            return nodedata;
        }
        
        private ImageIcon surfaceIcon;
        private ImageIcon electrodeIcon;
        private ImageIcon volumeIcon;
        private ImageIcon othersIcon;
        
        private Font noselectFont =  UIManager.getFont("Tree.font").deriveFont(Font.PLAIN);
        private Font selectFont=UIManager.getFont("Tree.font").deriveFont(Font.BOLD);
        
        public CheckBoxNodeRenderer() {
            if (noselectFont != null) 
            {
                panel.label.setFont(noselectFont);
                defaultRenderer.setFont(noselectFont);
            }
            
            
            final Boolean focusPainted =
            (Boolean) UIManager.get("Tree.drawsFocusBorderAroundIcon");
            panel.check.setFocusPainted(focusPainted != null && focusPainted);
            
            selectionForeground = UIManager.getColor("Tree.selectionForeground");
            selectionBackground = UIManager.getColor("Tree.selectionBackground");
            textForeground = UIManager.getColor("Tree.textForeground");
            textBackground = UIManager.getColor("Tree.textBackground");
            
//             defaultRenderer.setTextNonSelectionColor(textForeground);
//             defaultRenderer.setTextSelectionColor(selectionForeground);
//             defaultRenderer.setBorderSelectionColor(textForeground);
//             defaultRenderer.setBackgroundNonSelectionColor(textBackground);
//             defaultRenderer.setBackgroundSelectionColor(selectionBackground);
            
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
//                 panel.label.setFont(selectFont);
                panel.setForeground(selectionForeground);
                panel.setBackground(selectionBackground);
                panel.label.setForeground(selectionForeground);
                panel.label.setBackground(selectionBackground);
            }
            else {
//                 panel.label.setFont(noselectFont);
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
                
                if (selected)
                    defaultRenderer.setFont(selectFont);
                else
                    defaultRenderer.setFont(noselectFont);
                

                return defaultRenderer;
                
            }
            
            panel.label.setText(data.toString());
//         panel.label.setIcon(surfaceIcon);
            panel.check.setSelected(data.isChecked());
            
            nodedata.setText(data.getText());
            nodedata.setChecked(data.isChecked());
            nodedata.setID(data.getID());
            
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
    
    public class CheckBoxNodeEditor extends AbstractCellEditor implements
    TreeCellEditor
    {
        
        private final CheckBoxNodeRenderer renderer = new CheckBoxNodeRenderer();
        
        private final JTree theTree;
        
        public CheckBoxNodeEditor(final JTree tree) {
            theTree = tree;
        }
        
        @Override
        public Object getCellEditorValue() {
            final CheckBoxNodePanel panel = renderer.getPanel();
            final CheckBoxNodeData checkBoxNode = new CheckBoxNodeData(renderer.getNodeData().getText(),panel.check.isSelected(),renderer.getNodeData().getID());
            return checkBoxNode;
        }
        
        @Override
        public boolean isCellEditable(final EventObject event) {
            if (!(event instanceof MouseEvent)) return false;
            final MouseEvent mouseEvent = (MouseEvent) event;
            
            final TreePath path =
            theTree.getPathForLocation(mouseEvent.getX(), mouseEvent.getY());
            if (path == null) return false;
            
            final Object node = path.getLastPathComponent();
            if (!(node instanceof DefaultMutableTreeNode)) return false;
            final DefaultMutableTreeNode treeNode = (DefaultMutableTreeNode) node;
            
            final Object userObject = treeNode.getUserObject();
            return userObject instanceof CheckBoxNodeData;
        }
        
        @Override
        public Component getTreeCellEditorComponent(final JTree tree,
        final Object value, final boolean selected, final boolean expanded,
        final boolean leaf, final int row)
        {
            
            final Component editor =
            renderer.getTreeCellRendererComponent(tree, value, true, expanded, leaf,
            row, true);
            
            // editor always selected / focused
            final ItemListener itemListener = new ItemListener() {
                
                @Override
                public void itemStateChanged(final ItemEvent itemEvent) {
                    if (stopCellEditing()) {
                        fireEditingStopped();
                    }
                }
            };
            if (editor instanceof CheckBoxNodePanel) {
                final CheckBoxNodePanel panel = (CheckBoxNodePanel) editor;
                panel.check.addItemListener(itemListener);
            }
            
            return editor;
        }
    }
    
    public class CheckBoxNodeData {
        
        private String text;
        private boolean checked;
        private int id;
        
        public CheckBoxNodeData(final String text, final boolean checked, final int id) {
            this.text = text;
            this.checked = checked;
            this.id=id;
        }
        
        public int getID()
        {
            return id;
        }
        
        public void setID(int id)
        {
            this.id=id;
        }
        public boolean isChecked() {
            return checked;
        }
        
        public void setChecked(final boolean checked) {
            this.checked = checked;
        }
        
        public String getText() {
            return text;
        }
        
        public void setText(final String text) {
            this.text = text;
        }
        
        @Override
        public String toString() {
            
            File f=new File(text);
            return f.getName();
        }
        
    }
    private void expandAllNodes(JTree tree, int startingIndex, int rowCount)
    {
        for(int i=startingIndex;i<rowCount;++i){
            tree.expandRow(i);
        }
        
        if(tree.getRowCount()!=rowCount){
            expandAllNodes(tree, rowCount, tree.getRowCount());
        }
    }
}

