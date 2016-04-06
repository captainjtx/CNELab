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

/**
 * Illustrates usage of the check box tree in {@link org.scijava.swing.checkboxtree}.
 * <p>
 * Thanks to John Zukowski for the <a
 * href="http://www.java2s.com/Code/Java/Swing-JFC/CheckBoxNodeTreeSample.htm"
 * >sample code</a> upon which this is based.
 * </p>
 * 
 * @author Curtis Rueden
 */
public class CheckBoxTreeSample {

	public static void main(final String args[]) {
        JTree tree = new JTree();
        tree.setRootVisible( false );
        tree.setShowsRootHandles(true);
        
        DefaultMutableTreeNode rootNode = new DefaultMutableTreeNode("Objects");
        DefaultTreeModel defaultTreeModel = new DefaultTreeModel( rootNode );
        
        tree.setModel( defaultTreeModel );
        
        DefaultMutableTreeNode parentNode = null;
        DefaultMutableTreeNode node = null;
        
        parentNode = (DefaultMutableTreeNode) defaultTreeModel.getRoot();
        node = new DefaultMutableTreeNode( new DefaultMutableTreeNode("Surface"));
        addNodeToDefaultTreeModel( defaultTreeModel, parentNode, node );
        
        parentNode = node;
        node = new DefaultMutableTreeNode( new CheckBoxNodeData("cortex.mat",false) );
        addNodeToDefaultTreeModel( defaultTreeModel, parentNode, node );
        
        parentNode = rootNode;
        node = new DefaultMutableTreeNode( new DefaultMutableTreeNode("Rendering"));
        addNodeToDefaultTreeModel( defaultTreeModel, parentNode, node );
        
        parentNode = (DefaultMutableTreeNode) defaultTreeModel.getRoot();
        node = new DefaultMutableTreeNode( new DefaultMutableTreeNode("Electrode"));
        addNodeToDefaultTreeModel( defaultTreeModel, parentNode, node );
        
        parentNode = rootNode;
        node = new DefaultMutableTreeNode( new DefaultMutableTreeNode("Others") );
        addNodeToDefaultTreeModel( defaultTreeModel, parentNode, node );
        
        CheckBoxNodeRenderer renderer=new CheckBoxNodeRenderer();
        tree.setCellRenderer(new CheckBoxNodeRenderer());
        
		final CheckBoxNodeEditor editor = new CheckBoxNodeEditor(tree);
		tree.setCellEditor(editor);
		tree.setEditable(true);

		// listen for changes in the selection
		tree.addTreeSelectionListener(new TreeSelectionListener() {

			@Override
			public void valueChanged(final TreeSelectionEvent e) {
				System.out.println(System.currentTimeMillis() + ": selection changed");
			}
		});

		// listen for changes in the model (including check box toggles)
		defaultTreeModel.addTreeModelListener(new TreeModelListener() {

			@Override
			public void treeNodesChanged(final TreeModelEvent e) {
				System.out.println(System.currentTimeMillis() + ": nodes changed");
			}

			@Override
			public void treeNodesInserted(final TreeModelEvent e) {
				System.out.println(System.currentTimeMillis() + ": nodes inserted");
			}

			@Override
			public void treeNodesRemoved(final TreeModelEvent e) {
				System.out.println(System.currentTimeMillis() + ": nodes removed");
			}

			@Override
			public void treeStructureChanged(final TreeModelEvent e) {
				System.out.println(System.currentTimeMillis() + ": structure changed");
			}
		});

		// show the tree onscreen
		final JFrame frame = new JFrame("CheckBox Tree");
		final JScrollPane scrollPane = new JScrollPane(tree);
		frame.getContentPane().add(scrollPane, BorderLayout.CENTER);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.setSize(300, 150);
		frame.setVisible(true);
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
}
