package butelca.transport.service;

import java.io.*;

public class AuditService
{
    static AuditService auditService;
    BufferedWriter writer;
    private AuditService()
    {
        try{
            boolean newf = true;
            File f = new File("audit.csv");

            //Check if file is new
            if(f.exists())
                newf = false;

            //Open writer, if file is new also creates it
            writer = new BufferedWriter(new FileWriter(f, true));

            //Write header if file is new
            if(newf)
            {
                writer.write("Functie,Data");
                writer.newLine();
            }
            writer.flush();
        }
        catch (IOException e)
        {
            e.printStackTrace();
        }

    }


    public void logData(String funcName)
    {
        try{
            writer.write(funcName + "," + java.time.LocalDateTime.now().toString());
            writer.newLine();
            writer.flush();
        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
    }

    public static AuditService getAuditService()
    {
        if(auditService == null)
        {
            auditService = new AuditService();
        }

        return auditService;
    }
}
