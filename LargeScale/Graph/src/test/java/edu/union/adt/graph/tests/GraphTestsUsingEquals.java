package edu.union.adt.graph.tests;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.assertFalse;

import org.junit.Test;
import org.junit.Ignore;
import org.junit.Before;
import org.junit.After;
import org.junit.runner.RunWith;
import org.junit.runners.JUnit4;

import edu.union.adt.graph.Graph;
import edu.union.adt.graph.GraphFactory;

@RunWith(JUnit4.class)
public class GraphTestsUsingEquals
{
    private Graph<String> g;
    private Graph<String> g2;
    private Graph<Object> objectGraph;

    @Before
    public void setUp()
    {
        g = GraphFactory.<String>createGraph();
        g2 = GraphFactory.<String>createGraph();
        objectGraph = GraphFactory.<Object>createGraph();
    }

    @Test
    public void simpleEquals()
    {
        assertEquals("Two new graphs are equal", g, g2);
        assertEquals("Two new graphs are equal, even if vertex type differs",
                     g, objectGraph);
    }

    @Test
    public void addVertex()
    {
        g.addVertex("Foo");
        g2.addVertex("Foo");
        objectGraph.addVertex("Foo");

        assertEquals("Adding 'Foo' to two empty graphs produces same graph",
                     g, g2);
        assertEquals("Adding 'Foo' to two empty graphs produces same graph, "
                     + "even if the element types differ",
                     g, objectGraph);

        g2.addVertex("Foo");
        objectGraph.addVertex("Foo");

        assertEquals("Adding an already-present vertex has no effect",
                     g, g2);
        assertEquals("Adding an already-present vertex has no effect, "
                     + "even if the elements types differ",
                     g, objectGraph);
    }

    @Test
    public void addEdge()
    {
        g.addEdge("Foo", "Bar");
        g2.addEdge("Foo", "Bar");
        objectGraph.addEdge("Foo", "Bar");

        assertEquals("two graphs with same edges are equal",
                     g, g2);
        assertEquals("two graphs with same edges are equal, "
                     + "even if the element types differ",
                     g, objectGraph);

        g2.addEdge("Foo", "Bar");
        objectGraph.addEdge("Foo", "Bar");

        assertEquals("Adding an existing edge has no effect",
                     g, g2);
        assertEquals("Adding an existing edge has no effect, "
                     + "even if the element types differ",
                     g, objectGraph);
    }
}
