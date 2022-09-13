import matlab.engine
eng = matlab.engine.start_matlab()
path = r'C:\Users\Vagelis\Documents\Thesis_Algorithm\Algorithm\Python_Trial'
eng.cd(path, nargout=0)
eng.Main(nargout=0)

'''
If you want to run engine and get error matlab module not found
then:
1) Close pycharm and run it as administrator
2) Open pycharm's terminal and type the following commands
    cd "C:\Program Files\MATLAB\R2021b\extern\engines\python"
    python setup.py install
3) Ready!
'''