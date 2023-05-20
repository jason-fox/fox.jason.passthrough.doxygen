package fox.jason.passthrough;

import java.io.File;
import java.io.IOException;

public class DoxygenReader extends AntTaskFileReader {

  public DoxygenReader() {
  }

  private static final String ANT_FILE = "/../process_doxygen.xml";

  @Override
  protected String runTarget(File inputFile, String title)
    throws IOException {
    return executeAntTask(
      calculateJarPath(DoxygenReader.class) + ANT_FILE,
      inputFile,
      title
    );
  }
}
