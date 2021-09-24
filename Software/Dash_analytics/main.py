import time
from selenium import webdriver
import subprocess
import json
import threading as thr
import sys, os
path_dir =""
def kill_server():
    subprocess.run("lsof -t -i tcp:8049 | xargs kill -9", shell=True) # kill the server is a dash app is already running
def start_dash_app_frozen():
    path_dir = str(os.path.dirname(sys.executable))
    subprocess.Popen(path_dir+"/app", shell=False) # dash_app is the name that will be given to executabel dash app file
def start_driver():
    driver = webdriver.Chrome()
    time.sleep(5) # give dash app time to start running
    driver.get("http://0.0.0.0:8049/") # go to the local server
    save_browser_session(driver) # save the browser identity info
    print("DRIVER SAVED IN TEXT FILE browsersession.txt")
def save_browser_session(input_driver):
    driver = input_driver
    executor_url = driver.command_executor._url
    session_id = driver.session_id
    browser_file = path_dir+"/browsersession.txt"
    with open(browser_file, "w") as f:
        f.write(executor_url)
        f.write("\n")
        f.write(session_id)
def keep_server_running():
    while True:
        time.sleep(60)
        print("Next run for 60 seconds")
def main():
    kill_server() # kill open server on port
    thread = thr.Thread(target=start_dash_app_frozen) 
    thread.start() # start dash app on port
    start_driver() # start selenium controled chrome browser and go to port
    keep_server_running() # keep the main file running
if __name__ == '__main__':
    main()