package edu.union.adt.graph.tests.dubinskz;
import java.util.*;
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
public class ZachGraphTests
{
    private Graph<Integer> g;

    @Before
    public void setUp()
    {
        g = GraphFactory.<Integer>createGraph();
    }

    @Test
    public void addEdge()
    {
      g.addEdge(1,2);
      g.addEdge(1,2);
      g.removeEdge(1,2);
      assertEquals("Cannot have two edges to one vertex.",g.hasEdge(1,2),false);
    }

    @Test
    public void removeVertex()
    {
      g.addEdge(1,2);
      g.addEdge(2,3);
      g.addEdge(3,2);
      g.removeVertex(2);
      assertEquals("Removing a vertex removes invalid edges.",g.degree(1),0);
      assertEquals("Removing a vertex removes invalid edges.",g.degree(3),0);
      assertEquals("Removing a vertex ensures the vertex is removed.",g.contains(2),false);
    }

    @Test
    public void removeEdge()
    {
      g.addEdge(1,2);
      g.addEdge(2,3);
      g.addEdge(2,3);
      g.addEdge(3,2);
      Iterable<Integer> vertices = g.getVertices();
      g.removeEdge(2,3);
      assertEquals("Removing edges leaves vertices unchanged.",g.getVertices(),vertices);
    }

    @Test
    public void hasPath()
    {
      g.addEdge(1,2);
      g.addVertex(3);
      assertEquals("False is returned when there is no path.",g.hasPath(1,3),false);
      assertEquals("There are no paths to non-existant vertices.",g.hasPath(1,7),false);
      g.addEdge(2,3);
      assertEquals("True is returned when there is a path.",g.hasPath(1,3),true);
      for(Integer i : g.getVertices()){
        assertEquals("All elements have paths to themselves.",g.hasPath(i,i),true);
      }
    }

    @Test
    public void pathLength()
    {
      g.addEdge(1,2);
      g.addEdge(2,3);
      g.addEdge(2,4);
      g.addEdge(3,4);
      assertEquals("Shortest path is taken.",g.pathLength(1,4),2);
      assertEquals("Direction of edges is respected.",g.pathLength(4,1),Integer.MAX_VALUE);
      g.addVertex(5);
      for(Integer i : g.getVertices()){
        assertEquals("A trivial path has length 0.",g.pathLength(i,i),0);
        if(i != 5){assertEquals("A disconnected vertex has no paths.",g.pathLength(i,5),Integer.MAX_VALUE);}
      }
    }

    @Test
    public void getPath()
    {
        g.addEdge(1,2);
        g.addEdge(2,3);
        g.addEdge(3,4);
        g.addEdge(2,4);
        g.addEdge(4,5);
        ArrayList<Integer> p = new ArrayList<Integer>();
        p.add(1);
        p.add(2);
        p.add(4);
        assertEquals("Shortest path is returned.",g.getPath(1,4),p);
        g.addEdge(1,5);
        p.clear();
        p.add(1);
        p.add(5);
        assertEquals("Shortest path is returned with change in edges.",g.getPath(1,5),p);
    }

}
