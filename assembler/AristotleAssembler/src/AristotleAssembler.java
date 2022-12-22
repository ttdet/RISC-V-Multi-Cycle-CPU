import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Scanner;

public class AristotleAssembler {
    static final String INSTRUCTIONS_FILENAME = "instructions.txt";
    static final String PSEUDOINSTRUCTIONS_FILENAME = "pseudoinstructions.txt";
    boolean verbose = true;
    boolean debug = false;
    HashMap<String, String> instructions, pseudoInstructions;
    HashMap<String, Integer> labels;
    HashSet<String> cType;
    Scanner sc;
    File input, output, outputHex;
    int errors;

    public static void main(String[] args) throws IOException {
        new AristotleAssembler(args);
    }

    public AristotleAssembler(String[] args) throws IOException {
        sc = new Scanner(System.in);
        errors = 0;
        String in, out;
        if (verbose)
            System.out.printf("Current working directory: \"%s\"\n", System.getProperty("user.dir"));
        if (args.length < 2 || args[0].equals("help")) {
            System.out.println(
                    "Command line usage: AristotleAssembler.java <input> <output> [-v|--verbose] [-d|--debug]");
            if (args.length != 0)
                System.exit(0);
            System.out.println("This tool offers an interactive version. Enter your file input path to continue.");
            in = sc.nextLine();
            System.out.println("Enter your file output path");
            out = sc.nextLine();
        } else {
            in = args[0];
            out = args[1];
            if (args.length > 2) {
                String flags = args[2];
                for (int i = 3; i < args.length; i++) {
                    flags += args[i];
                }
                verbose = flags.contains("-v") || flags.contains("--verbose") || flags.contains("-dv")
                        || flags.contains("-vd");
                debug = flags.contains("-d") || flags.contains("--debug") || flags.contains("-dv")
                        || flags.contains("-vd");
                ;
            }
        }
        sc.close();

        if (verbose || debug) {
            System.out.println("---- Aristotle Assembler ----");
            System.out.println("Input file: " + in);
            System.out.println("Output file: " + out);
            System.out.println("Verbose: " + verbose);
            System.out.println("Debug: " + debug);
            System.out.println("-----------------------------\n");
        }

        verifyFilePaths(in, out);
        if (verbose)
            System.out.println();
        buildInstructionMap();
        if (verbose)
            System.out.println();
        computeBranchNames();
        if (verbose)
            System.out.println();
        parseFile(in, out);
        if (verbose)
            System.out.println();
        binaryToHex();
        System.out.println("\nAssembler process completed with " + errors + " errors.");
    }

    /**
     * Reads the input file and stores the location of each label in a HashMap
     */
    private void computeBranchNames() throws FileNotFoundException {
        if (verbose)
            System.out.print("Computing branch label locations... ");
        sc = new Scanner(input);
        labels = new HashMap<String, Integer>();
        int lineCount = 0;
        for (int counter = 0; sc.hasNextLine(); counter++) {
            String line = sc.nextLine();
            lineCount++;
            if (line.contains(":")) {
                if (debug)
                    System.out.printf("\nFound label %s at line %d", line.split(":")[0], lineCount);
                labels.put(line.split(":")[0], counter);
            }
            if (pseudoInstructions.keySet().contains(line.split(" ")[0])) {
                counter += pseudoInstructions.get(line.split(" ")[0]).split(",").length - 1;
            }
            if (!instructions.keySet().contains(line.split(" ")[0])
                    && !pseudoInstructions.keySet().contains(line.split(" ")[0]))
                counter--;
        }
        sc.close();
        if (debug)
            System.out.println();
        if (verbose)
            System.out.println("done");
    }

    /**
     * Verifies that the input and output files exist and are readable or writable
     * 
     * @param in  The input file
     * @param out The output file name
     */
    private void verifyFilePaths(String in, String out) throws IOException {
        if (verbose)
            System.out.printf("Verifying '%s' exists and is readable... ", in);
        input = new File(in);
        if (!input.canRead()) {
            System.err.printf("Cannot read file '%s'. Are you in the right directory?\n", in);
            System.exit(0);
        }
        if (verbose)
            System.out.println("done");

        if (verbose)
            System.out.printf("Verifying '%s' exists and is writable... ", out);
        output = new File(out);
        output.createNewFile();
        if (!output.canWrite()) {
            System.err.printf("Cannot write to file '%s'. Are you in the right directory?\n", out);
            System.exit(0);
        }
        if (verbose)
            System.out.println("done");

        if (verbose)
            System.out.printf("Verifying '%s.hex' exists and is writable... ", out);
        outputHex = new File(out + ".hex");
        outputHex.createNewFile();
        if (!outputHex.canWrite()) {
            System.err.printf("Cannot write to file '%s.hex'. Are you in the right directory?\n", out);
            System.exit(0);
        }
        if (verbose)
            System.out.println("done");
    }

    /**
     * Reads a file line by line, and if the line is a valid instruction, it writes
     * the machine code to the output file
     * 
     * @param in  The input file
     * @param out The output file
     */
    private void parseFile(String in, String out) throws IOException {
        if (verbose)
            System.out.printf("Reading file '%s' and writing to file '%s'... ", in, out);
        sc = new Scanner(input);
        FileWriter fw = new FileWriter(output);
        int lineCount = 0;
        for (int counter = 0; sc.hasNextLine(); counter++) {
            String line = sc.nextLine();
            lineCount++;
            String[] lineArr = (line.length() > 0) ? line.split(" ") : new String[1];
            if (lineArr[0] == null) {
            } else if (!instructions.keySet().contains(lineArr[0]) && !pseudoInstructions.keySet().contains(lineArr[0])
                    && !labels.containsKey(lineArr[0].split(":")[0])) {
                if (lineArr[0] != null && !lineArr[0].substring(0, 2).equals("//")) {
                    System.out.printf("\nError at line %d: '%s' is not a valid instruction.", lineCount, lineArr[0]);
                    errors++;
                }
            }
            if (instructions.keySet().contains(lineArr[0])) {
                if (!writeMachineInstruction(fw, lineArr, counter)) {
                    System.out.printf("\nError at line %d: '%s' has invalid parameters.", lineCount, lineArr[0]);
                    errors++;
                }
            } else {
                if (pseudoInstructions.keySet().contains(lineArr[0])) {
                    String[] pseudo = pseudoInstructions.get(lineArr[0]).split(",");
                    for (String s : pseudo) {
                        String[] pseudoLineArr = s.split(" ");
                        for (int i = 0; i < pseudoLineArr.length; i++) {
                            if (lineArr.length > 1)
                                pseudoLineArr[i] = pseudoLineArr[i].replace("rs1", lineArr[1]);
                            if (lineArr.length > 2)
                                pseudoLineArr[i] = pseudoLineArr[i].replace("rs2", lineArr[2]);
                        }
                        if (!writeMachineInstruction(fw, pseudoLineArr, counter)) {
                            System.out.printf("\nError at line %d: '%s' has invalid parameters.", lineCount,
                                    lineArr[0]);
                            errors++;
                        }
                        counter++;
                    }
                }
                counter--;
            }
        }
        sc.close();
        fw.close();
        if (debug)
            System.out.println();
        if (verbose)
            System.out.println("done");
    }

    /**
     * Takes a line of assembly code and converts it to machine code
     * 
     * @param fw      FileWriter
     * @param lineArr The array of the current line split by spaces
     * @param counter the current line number
     */
    private boolean writeMachineInstruction(FileWriter fw, String[] lineArr, int counter) throws IOException {
        if (debug)
            System.out.print("\n" + Arrays.toString(lineArr));
        String lastPrint = "";
        boolean instructionValid = true;
        try {
            if (cType.contains(lineArr[0])) {
                String binString = null;
                if (lineArr.length > 1) {
                    if (labels.keySet().contains(lineArr[1])) {
                        lineArr[1] = Integer.toString(labels.get(lineArr[1]) - counter - 1);
                        if (debug)
                            System.out.print(" (branch: " + lineArr[1] + ")");
                    }
                    binString = Integer.toBinaryString(Integer.parseInt(lineArr[1]));
                }
                if (binString == null) {
                    lastPrint += "00000000000";
                    fw.append("00000000000");
                } else {
                    lastPrint += ("00000000000" + binString).substring(binString.length());
                    fw.append(("00000000000" + binString).substring(binString.length()));
                }
            } else {
                lastPrint += "0";
                fw.append("0");
                for (int i = 2; i > 0; i--) {
                    try {
                        String binString = Integer.toBinaryString(Integer.parseInt(lineArr[i]));
                        lastPrint += ("00000" + binString).substring(binString.length());
                        fw.append(("00000" + binString).substring(binString.length()));
                    } catch (Exception e) {
                        lastPrint += "00000";
                        fw.append("00000");
                    }
                }
            }
        } catch (NumberFormatException e) {
            instructionValid = false;
        }
        lastPrint += instructions.get(lineArr[0]);
        fw.append(instructions.get(lineArr[0]) + "\n");
        if (debug)
            System.out.print(" " + lastPrint);
        return instructionValid;
    }

    /**
     * Reads in instructions.txt and pseudoinstructions.txt and stores the
     * information in a HashMap
     */
    private void buildInstructionMap() {
        if (verbose)
            System.out.print("Building instruction map... ");
        File instructionFile = new File(INSTRUCTIONS_FILENAME);
        try {
            sc = new Scanner(instructionFile);
        } catch (FileNotFoundException e) {
            System.err.printf(
                    "No instruction file found. Create a file called %s in the root directory with proper format.\n",
                    INSTRUCTIONS_FILENAME);
            System.exit(0);
        }
        instructions = new HashMap<String, String>();
        cType = new HashSet<String>();
        boolean start = false;
        while (sc.hasNextLine()) {
            if (start) {
                String[] line = sc.nextLine().split(" ");
                instructions.put(line[0], ("00000" + line[2]).substring(line[2].length()));
                if (line[1].toLowerCase().equals("c"))
                    cType.add(line[0]);
            } else if (sc.nextLine().equals("?start")) {
                start = true;
            }
        }
        sc.close();
        if (verbose)
            System.out.print("done\nBuilding pseudoinstruction map... ");
        instructionFile = new File(PSEUDOINSTRUCTIONS_FILENAME);
        try {
            sc = new Scanner(instructionFile);
        } catch (FileNotFoundException e) {
            System.err.printf(
                    "No pseudoinstruction file found. Create a new file called %s in the root directory with proper format.\n",
                    PSEUDOINSTRUCTIONS_FILENAME);
            System.exit(0);
        }
        pseudoInstructions = new HashMap<String, String>();
        start = false;
        while (sc.hasNextLine()) {
            if (start) {
                String[] line = sc.nextLine().split(":");
                pseudoInstructions.put(line[0], line[1]);
            } else if (sc.nextLine().equals("?start")) {
                start = true;
            }
        }
        if (verbose)
            System.out.println("done");
    }

    /**
     * It reads a file containing binary numbers, converts them to hexadecimal, and
     * writes the hexadecimal numbers to a new file
     */
    public void binaryToHex() throws IOException {
        if (verbose)
            System.out.print("Converting binary output to hex... ");
        sc = new Scanner(output);
        FileWriter fw = new FileWriter(outputHex);
        while (sc.hasNextLine()) {
            String line = sc.nextLine();
            String hex = Integer.toHexString(Integer.parseInt(line, 2));
            fw.append(("0000" + hex).substring(hex.length()) + "\n");
        }
        sc.close();
        fw.close();
        if (verbose)
            System.out.println("done");
    }
}