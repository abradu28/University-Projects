package butelca.transport.service;

import butelca.transport.model.Client;
import butelca.transport.model.FileService;
import butelca.transport.repository.ClientRepository;

import java.io.*;

public class ClientFileService implements FileService
{
    static ClientFileService clientFileService;

    private ClientRepository clientRepository;

    private ClientFileService(ClientRepository cr) {
        clientRepository = cr;
    }

    public void loadData()
    {
        try{
            File f = new File("client_data.csv");

            //Check if file is new
            if(!f.exists())
                return;

            BufferedReader input = new BufferedReader(new FileReader(f));

            String line;
            while((line = input.readLine()) != null)
            {
                String[] values = line.split(",");
                Client c = new Client(Integer.parseInt(values[0]),values[1],values[2],values[3]);
                clientRepository.addClient(c);
            }

        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
    }

    public void saveData()
    {
        try{
            File f = new File("client_data.csv");

            BufferedWriter output = new BufferedWriter(new FileWriter(f));

            for(Client c : clientRepository.getClients())
            {
                output.write(Integer.toString(c.getId()));
                output.write(",");
                output.write(c.getFirstName());
                output.write(",");
                output.write(c.getLastName());
                output.write(",");
                output.write(c.getPhoneNumber());
                output.newLine();
                output.flush();
            }

        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
    }

    public static ClientFileService getFileService(ClientRepository clientRepository)
    {
        if(clientFileService == null)
        {
            clientFileService = new ClientFileService(clientRepository);
        }

        return clientFileService;
    }
}
