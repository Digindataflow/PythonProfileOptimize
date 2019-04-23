from gevent import monkey
monkey.patch_socket()
import gevent
from gevent.core import Semaphore
import string
import random
import urllib.request

def generate_urls(base_url, num_urls):
    for i in range(num_urls):
        yield base_url + "".join(random.sample(string.ascii_lowercase, 10))

def chunked_requests(urls, chunk_size=100):
    # limit the size of greentlets to avoid to frequent switch between greenlets
    semaphore = Semaphore(chunk_size)
    # queue up as many greenlets as we need
    requests = [gevent.spawn(download, u, semaphore) for u in urls] #
    for response in gevent.iwait(requests):
        yield response

def download(url, semaphore):
    with semaphore:
        data = urllib.request.urlopen(url)
        return data.read()

def run_experiment(base_url, num_iter=500):
    urls = generate_urls(base_url, num_iter)
    response_futures = chunked_requests(urls, 100) #
    response_size = sum(len(r.value) for r in response_futures)
    return response_size

if __name__ == "__main__":
    import time
    delay = 100
    num_iter = 500
    base_url = "http://127.0.0.1:8080/add?name=gevent&delay={}&".format(delay)
    start = time.time()
    result = run_experiment(base_url, num_iter)
    end = time.time()
    print("Result: {}, Time: {}".format(result, end - start))