package checkboxtree;

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

import checkboxtree.CheckBoxNodeData;
import checkboxtree.CheckBoxNodeEditor;
import checkboxtree.CheckBoxNodeRenderer;

import javax.swing.ImageIcon;

public class FileLoadTree extends JScrollPane
{
    private JTree tree;
    private DefaultMutableTreeNode SurfaceNode = null;
    private DefaultMutableTreeNode ElectrodeNode = null;
    private DefaultMutableTreeNode VolumeNode = null;
    private DefaultMutableTreeNode OthersNode = null;
    private DefaultTreeModel defaultTreeModel;
    
    public FileLoadTree()
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
        
        // listen for changes in the selection
        tree.addTreeSelectionListener(new TreeSelectionListener() {
            
            @Override
            public void valueChanged(final TreeSelectionEvent e) {
//                 System.out.println(System.currentTimeMillis() + ": selection changed");
            }
        });
        
        // listen for changes in the model (including check box toggles)
        defaultTreeModel.addTreeModelListener(new TreeModelListener() {
            
            @Override
            public void treeNodesChanged(final TreeModelEvent e) {
//                 System.out.println(System.currentTimeMillis() + ": nodes changed");
            }
            
            @Override
            public void treeNodesInserted(final TreeModelEvent e) {
//                 System.out.println(System.currentTimeMillis() + ": nodes inserted");
            }
            
            @Override
            public void treeNodesRemoved(final TreeModelEvent e) {
//                 System.out.println(System.currentTimeMillis() + ": nodes removed");
            }
            
            @Override
            public void treeStructureChanged(final TreeModelEvent e) {
//                 System.out.println(System.currentTimeMillis() + ": structure changed");
            }
        });
        
        setViewportView(tree);
    }
    private static DefaultMutableTreeNode add(
    final DefaultMutableTreeNode parent, final String text,
    final boolean checked)
    {
        final CheckBoxNodeData data = new CheckBoxNodeData(text, checked);
        final DefaultMutableTreeNode node = new DefaultMutableTreeNode(data);
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
    
    public void addSurface(String filename)
    {
        DefaultMutableTreeNode node = new DefaultMutableTreeNode( new CheckBoxNodeData(filename,false) );
        addNodeToDefaultTreeModel( defaultTreeModel, SurfaceNode, node );
    }
    public void addVolume(String filename)
    {
        
        DefaultMutableTreeNode node = new DefaultMutableTreeNode( new CheckBoxNodeData(filename,false) );
        addNodeToDefaultTreeModel( defaultTreeModel, VolumeNode, node );
        
    }
    public void addElectrode(String filename)
    {
        
        DefaultMutableTreeNode node = new DefaultMutableTreeNode( new CheckBoxNodeData(filename,false) );
        addNodeToDefaultTreeModel( defaultTreeModel, ElectrodeNode, node );
        
    }
    public void addOthers(String filename)
    {
        DefaultMutableTreeNode node = new DefaultMutableTreeNode( new CheckBoxNodeData(filename,false) );
        addNodeToDefaultTreeModel( defaultTreeModel, OthersNode, node );
        
    }
    
}
