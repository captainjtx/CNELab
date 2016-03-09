import java.util.LinkedList;
public class globalVar {
    public static String CNELAB_PATH;
    public static LinkedList RECENT_FILES;
    
    public static void setCnelabPath(String p)
    {
        CNELAB_PATH=p;
    }
    public static void setRecentFiles(LinkedList f)
    {
        RECENT_FILES=f;
    }
};