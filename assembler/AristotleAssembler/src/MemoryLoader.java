import java.io.IOException;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.util.Scanner;

public class MemoryLoader {

    private static final String ASM_INSTRUCTION_FILENAME = "in";
    private static final String MACHINE_INSTRUCTION_FILENAME = "machineInstructions";
    private static final String MACHINE_INSTRUCTION_FILE = "machineInstructions.hex";

    private static final String MEMORY_FILENAME = "memory.txt";

    public static void main(String[] args) throws IOException, FileNotFoundException {

        AristotleAssembler.main(new String[] { ASM_INSTRUCTION_FILENAME, MACHINE_INSTRUCTION_FILENAME });

        File machineCode = new File(MACHINE_INSTRUCTION_FILE);
        File memory = new File(MEMORY_FILENAME);

        Scanner s = null;
        FileWriter fw = null;

        s = new Scanner(machineCode);
        fw = new FileWriter(memory);

        for (int memPointer = 0; memPointer < 255; memPointer++) {
            String nextLine = "";
            if (s.hasNextLine()) {
                nextLine = s.nextLine() + "\n";
            } else
                nextLine = "0000\n";

            fw.append(nextLine);

        }

        fw.append("0000");

        fw.close();
        s.close();

    }

}