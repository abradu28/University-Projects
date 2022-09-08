package butelca.transport.model;

import java.util.ArrayList;
import java.util.List;

public class Route
{
    private ArrayList<Link> links;
    private City from,to;

    public Route(ArrayList<Link> links, City from, City to) {
        this.links = links;
        this.from = from;
        this.to = to;
    }

    public List<Link> getLinks() {
        return links;
    }

    public void setLinks(ArrayList<Link> links) {
        this.links = links;
    }

    public City getFrom() {
        return from;
    }

    public void setFrom(City from) {
        this.from = from;
    }

    public City getTo() {
        return to;
    }

    public void setTo(City to) {
        this.to = to;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        for(Link l :links)
            sb.append(l).append("\n");
        return "Route " +
                "links:" + sb.toString() +
                " from: " + from +
                " to: " + to;
    }
}
