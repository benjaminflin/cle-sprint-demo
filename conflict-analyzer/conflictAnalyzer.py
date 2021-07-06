#!/bin/python3

import os
import sys
import zmq
import argparse
import json

if __name__ == "__main__":

    parser = argparse.ArgumentParser(
        description="""
        """
    )

    parser.add_argument('--files','-f', type=str, 
                    help='files to process')

    parser.add_argument('--zmq','-z', type=str, 
                    help='ZMQ IP Address (tcp://XXX.XXX.XXX.XXX:PORT)')

    args = parser.parse_args()

    conflict_analyzer_path = '~/gaps/sprint-demo/conflict-analyzer/conflictAnalyzer.sh'
    os.system(f"{conflict_analyzer_path} {args.files} 2> result.txt")
    if args.zmq:
        context = zmq.Context()
        socket = context.socket(zmq.REQ)
        socket.connect(args.zmq)
        with open('result.txt') as f:
            if '=====UNSATISFIABLE=====' in f.read():
                message = json.dumps({"result" : "Conflict"})
            else:
                message = json.dumps({"result" : "Success"})
        socket.send_string(message)

    with open('result.txt') as f:
        if '=====UNSATISFIABLE=====' in f.read():
            print("Conflict")
        else:
            print("Success")
        
        