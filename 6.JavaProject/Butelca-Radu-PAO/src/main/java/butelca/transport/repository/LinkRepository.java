package butelca.transport.repository;

import butelca.transport.model.City;
import butelca.transport.model.Link;

import java.util.ArrayList;

public class LinkRepository
{
    private int lastId;
    private ArrayList<Link> links;

    public LinkRepository()
    {
        links = new ArrayList<>();
        lastId = 0;
    }

    public void addLink(Link l)
    {
        links.add(l);
        lastId++;
    }

    public void removeLink(Link l)
    {
        links.remove(l);
    }
    public void removeLinkById(int id)
    {
        for (Link l : links)
            if(l.getLinkId() == id)
            {
                links.remove(l);
                break;
            }
    }

    public int getLastId() {
        return lastId;
    }

    public Link getShortestLink(City c1, City c2, boolean byTime)
    {
        Link response = null;
        float minVal = Float.POSITIVE_INFINITY;
        for(Link l :links)
        {
            float val;
            if(byTime)
                val = l.getDuration();
            else
                val = l.getLength();

            if (l.linksCities(c1, c2) && val < minVal) {
                response = l;
                minVal = val;
            }
        }
        return response;
    }

    public ArrayList<Link> getLinks() {
        return links;
    }
}
