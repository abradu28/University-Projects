package butelca.transport.service;

import butelca.transport.main.Main;
import butelca.transport.model.City;
import butelca.transport.model.Link;
import butelca.transport.repository.LinkRepository;
import butelca.transport.model.*;

import java.util.Scanner;

public class LinkService
{
    LinkRepository linkRepository;
    AuditService auditService;

    public LinkService()
    {
        linkRepository = new LinkRepository();
        auditService = AuditService.getAuditService();
    }

    public Link addLink(Scanner s)
    {
        System.out.println("Enter first city name: ");
        City c1 = Main.cityService.getCityByName(s.next());
        if(c1==null)
        {
            System.out.println("City doesn't exist!");
            return null;
        }

        System.out.println("Enter second city name: ");
        City c2 = Main.cityService.getCityByName(s.next());
        if(c2==null)
        {
            System.out.println("City doesn't exist!");
            return null;
        }

        System.out.println("Enter link length: ");
        float length = s.nextFloat();

        System.out.println("Enter link duration: ");
        float duration = s.nextFloat();

        Link l = new Link(linkRepository.getLastId(), c1, c2, length, duration);
        linkRepository.addLink(l);

        auditService.logData("LinkService_addLink");
        return l;
    }

    public void removeLinkById(int id)
    {
        linkRepository.removeLinkById(id);
        auditService.logData("LinkService_removeLinkById");
    }

    public Link getShortestLink(City city1,City city2,boolean byTime)
    {
        auditService.logData("LinkService_getShortestLink");
        return linkRepository.getShortestLink(city1,city2,byTime);
    }

    public String allLinks()
    {
        auditService.logData("LinkService_allLinks");

        StringBuilder res = new StringBuilder();
        for(Link l : linkRepository.getLinks())
        {
            res.append(l.toString()).append("\n");
        }
        return res.toString();
    }
}
