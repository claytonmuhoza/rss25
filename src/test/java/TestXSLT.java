import org.junit.jupiter.api.Test;

import javax.xml.transform.*;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.File;

public class TestXSLT {
    @Test
    public void createHTML() throws TransformerException {
        File xsltFile = new File("src/main/ressources/rss25.tp4.xslt");
        File xmlFile = new File("src/main/ressources/rss25.tp3.xml");
        File htmlFile = new File("src/main/ressources/transformation1.html");
        StreamResult htmlSource = new StreamResult(htmlFile);
        StreamSource xmlSource = new StreamSource(xmlFile);
        StreamSource xsltSource = new StreamSource(xsltFile);
        Transformer transformer = TransformerFactory.newInstance().newTransformer(xsltSource);
        transformer.setOutputProperty(OutputKeys.METHOD,"html");
        transformer.setOutputProperty(OutputKeys.ENCODING,"UTF-8");
        transformer.setOutputProperty(OutputKeys.INDENT,"yes");
        transformer.setOutputProperty(OutputKeys.DOCTYPE_SYSTEM,"");
        transformer.transform(xmlSource, htmlSource);
    }

}
