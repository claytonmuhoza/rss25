package fr.univrouen.rss25;

import java.io.File;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;
import org.xml.sax.SAXParseException;
import org.xml.sax.XMLReader;

import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;

import static org.junit.jupiter.api.Assertions.*;

public class TestXML {
	@Test
    public void testResources() {
        //Given
        boolean erreur = false;
        File xsdFile = new File("src/main/ressources/rss25.tp1.xsd");
        File xmlFile = new File("src/main/ressources/rss25.tp2a.xml");
        //when
        if (!xsdFile.exists()) {
            erreur = true;
        }
        if (!xmlFile.exists()) {
            erreur = true;
        }
        //Then
        assertFalse(erreur, "le fichier XMl n'est pas valide");
    }
    @Test
    @DisplayName("Validation d'un fichier XML par un schèma XSD avec l'api DOM")
    public void test_with_DOM() {
        // Given
        SimpleErrorHandler errorHandler = new SimpleErrorHandler();
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        factory.setNamespaceAware(true);

        try {
            SchemaFactory schemaFactory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
            Schema schema = schemaFactory.newSchema(new File("src/main/ressources/rss25.tp1.xsd"));
            factory.setSchema(schema);
            DocumentBuilder builder = factory.newDocumentBuilder();
            builder.setErrorHandler(errorHandler);

            // When
            Document document = builder.parse(new File("src/main/ressources/rss25.tp2a.xml"));
        } catch (Exception e) {
            fail("Validation failed due to exception: " + e.getMessage());
        }

        // Then
        assertFalse(errorHandler.hasError(), "le fichier XML n'est pas valide");
    }
    @Test
    @DisplayName("Validé un fichier XML en utilisant un schèma XSD avec SAX")
    public void test_with_SAX() {
        //Given
        SimpleErrorHandler errorHandler = new SimpleErrorHandler();
        //When
        try {
            SAXParserFactory factory = SAXParserFactory.newInstance();
            factory.setNamespaceAware(true);
            SchemaFactory schemaFactory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
            Schema schema = schemaFactory.newSchema(new File("src/main/ressources/rss25.tp1.xsd"));
            factory.setSchema(schema);
            SAXParser parser = factory.newSAXParser();
            XMLReader reader = parser.getXMLReader();
            reader.setErrorHandler(errorHandler);

            reader.parse(new InputSource("src/main/ressources/rss25.tp2a.xml"));
        } catch (Exception e) {
            fail("La validation a échoué:  " + e.getMessage());
        }
        //Then
        assertFalse(errorHandler.hasError(), "le fichier XML n'est pas valide");
    }
    @ParameterizedTest(name = "Fichier: {0} doit être valide: {1}")
    @CsvSource({
            "src/main/ressources/rss25.tp2b.xml, true",
            "src/main/ressources/rss25.tp2d.xml, false"
    })
    @DisplayName("Validation XML avec DOM paramétrée")
    public void test_with_DOM(String xmlFilename, boolean expectedValidity) {
        SimpleErrorHandler errorHandler = new SimpleErrorHandler();
        try {
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            factory.setNamespaceAware(true);
            SchemaFactory schemaFactory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
            Schema schema = schemaFactory.newSchema(new File("src/main/ressources/rss25.tp1.xsd"));
            factory.setSchema(schema);
            DocumentBuilder builder = factory.newDocumentBuilder();
            builder.setErrorHandler(errorHandler);
            Document document = builder.parse(new File(xmlFilename));
        } catch (Exception e) {
            fail("La validation a échoué:  " + e.getMessage());
        }
        boolean isValid = !errorHandler.hasError();
        assertEquals(expectedValidity, isValid, "La validité du fichier " + xmlFilename + " est incorrecte.");
    }
    @ParameterizedTest(name = "Fichier: {0} doit être valide: {1}")
    @CsvSource({
            "src/main/ressources/rss25.tp2a.xml, true",
            "src/main/ressources/rss25.tp2c.xml, false"
    })
    @DisplayName("Validation XML avec SAX paramétrée")
    public void test_with_SAX(String xmlFilename, boolean expectedValidity) {
        SimpleErrorHandler errorHandler = new SimpleErrorHandler();
        try {
            SAXParserFactory factory = SAXParserFactory.newInstance();
            factory.setNamespaceAware(true);
            SchemaFactory schemaFactory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
            Schema schema = schemaFactory.newSchema(new File("src/main/ressources/rss25.tp1.xsd"));
            factory.setSchema(schema);

            SAXParser parser = factory.newSAXParser();
            XMLReader reader = parser.getXMLReader();
            reader.setErrorHandler(errorHandler);
            reader.parse(new InputSource(xmlFilename));
        } catch (Exception e) {
            fail("La validation a échoué:  " + e.getMessage());
        }
        boolean isValid = !errorHandler.hasError();
        assertEquals(expectedValidity, isValid, "La validité du fichier " + xmlFilename + " est incorrecte.");
    }
}
