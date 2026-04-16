'''
python tools/hacks/base64decode.py `
    tools/hacks/ignoreme-b64.txt `
    tools/hacks/ignoreme-b64.zip
'''

import argparse
import base64

def decode_base64(encoded_str):
    try:
        if not isinstance(encoded_str, str):
            raise TypeError("Input must be a string.")
        decoded_bytes = base64.b64decode(encoded_str, validate=True)

        try:
            return decoded_bytes.decode('utf-8')
        except UnicodeDecodeError:
            return decoded_bytes

    except (base64.binascii.Error, ValueError) as e:
        return f"Invalid Base64 input: {e}"


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Process input and output paths.")

    parser.add_argument("input", type=str, help="Path to the input file")
    parser.add_argument("output", type=str, help="Path to the output file")

    args = parser.parse_args()

    with open(args.input, 'r', encoding='utf-8') as r:
        b64 = r.read().replace('\n', '')
    res = decode_base64(b64)
    if isinstance(res, str):
        with open(args.input, 'w', encoding='utf-8') as w:
            w.write(res)
    else:
        with open(args.output, 'wb') as wb:
            wb.write(res)
    print(f'"{args.output}"')
