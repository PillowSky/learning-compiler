import java.io.FileReader;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Main {
	public static void main(String args[]) throws IOException {
		if (args.length != 1) {
			System.out.println("Usage: java Main <filename>");
			System.exit(1);
		}

		String filename = args[0];
		HashMap<String, LinkedList<HashMap<String, String>>> database = new HashMap<>();
		Pattern regex = Pattern.compile("^(.*): \\[(.*)\\] ([^:\\n ]*)(: ?(.*))?$");

		BufferedReader reader = new BufferedReader(new FileReader(filename));
		String line;
		while ((line = reader.readLine()) != null) {
			Matcher m = regex.matcher(line);
			if (m.matches()) {
				String timestamp = m.group(1);
				String action = m.group(2);
				String username = m.group(3);
				String message = (m.group(5) != null) ? m.group(5) : "";
				HashMap<String, String> data = new HashMap<>();
				data.put("timestamp", timestamp);
				data.put("action", action);
				data.put("message", message);

				LinkedList<HashMap<String, String>> record = database.get(username);
				if (record != null) {
					record.push(data);
				} else {
					record = new LinkedList<>();
					record.push(data);
					database.put(username, record);
				}
			}
		}
		reader.close();

		for (HashMap.Entry<String, LinkedList<HashMap<String, String>>> entry : database.entrySet()) {
			String username = entry.getKey();
			LinkedList<HashMap<String, String>> record = entry.getValue();
			System.out.format("Logs for %s:%n", username);
			for (HashMap<String, String> r : record) {
				System.out.format("\t%s [%s] %s%n", r.get("timestamp"), r.get("action"), r.get("message"));
			}
			System.out.println();
		}
	}
}
