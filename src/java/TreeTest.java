import javax.swing.JFrame;
import java.awt.BorderLayout;

public class TreeTest {
  public static void main(String args[]) {
    JFrame frame = new JFrame("CheckBox Tree");
    frame.getContentPane().add(new CheckBoxNodeTree(), BorderLayout.CENTER);
    frame.setSize(300, 150);
    frame.setVisible(true);
  }
}