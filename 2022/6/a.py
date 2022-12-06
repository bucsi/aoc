START_OF_PACKET_LEN = 4
START_OF_MSG_LEN = 14

with open('sample.txt', 'r') as infile:
    streams = infile.readlines()

with open('input.txt', 'r') as infile:
    streams.append(infile.read())

for stream in streams:
    start_of_packet_found = False
    for i in range(len(stream)):
        possible_packet_marker = set(stream[i:i + START_OF_PACKET_LEN])
        possible_msg_marker = set(stream[i:i + START_OF_MSG_LEN])

        if (not start_of_packet_found and
                len(possible_packet_marker) == START_OF_PACKET_LEN):
            start_of_packet_found = True
            print(f"start of packet after char {i + START_OF_PACKET_LEN}")

        if len(possible_msg_marker) == START_OF_MSG_LEN:
            start_of_packet_found = True
            print(f"start of message after char {i + START_OF_MSG_LEN}")
            print()
            break
