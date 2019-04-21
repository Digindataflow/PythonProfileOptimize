import multiprocessing

def worker(num, **kwargs):
    return num + kwargs.get("code")

def run():
    with multiprocessing.Pool(4) as pool:
        results = [pool.apply_async(
            func=worker, args=(i,), kwds={'code':2}) for i in range(5)]
    return [res.get() for res in results]

if __name__=='__main__':
    multiprocessing.freeze_support()
    run()