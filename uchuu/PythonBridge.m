#import "PythonBridge.h"
#import "Support/Python/Headers/Python.h"

@implementation PythonBridge

+(NSData*)run:(NSString *)url{
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *python_home;
    wchar_t *wpython_home;
    NSString *python_path;
    NSString *tmp_path;

    putenv("PYTHONOPTIMIZE=1");
    putenv("PYTHONDONTWRITEBYTECODE=1");
    putenv("PYTHONUNBUFFERED=1");
    
    python_home = [NSString stringWithFormat:@"%@/Support/Python", resourcePath, nil];
    wpython_home = Py_DecodeLocale([python_home UTF8String], NULL);
    Py_SetPythonHome(wpython_home);

    python_path = [NSString stringWithFormat:@"PYTHONPATH=%@/Support/Python/Resources/lib/python36.zip:%@/Support/imports/youtube-dl:%@/Support/imports/service", resourcePath, resourcePath, resourcePath, nil];
    putenv((char *)[python_path UTF8String]);

    tmp_path = [NSString stringWithFormat:@"TMP=%@/tmp", resourcePath, nil];
    putenv((char *)[tmp_path UTF8String]);

    Py_Initialize();
    PyObject *ytdl_hook = PyImport_ImportModule("ytdl_hook");
    PyObject *get_json_info_for = PyObject_GetAttrString(ytdl_hook, "get_json_info_for");
    PyObject *url_string = PyUnicode_FromString([url UTF8String]);
    PyObject *args = PyTuple_Pack(1, url_string);
    PyObject *py_result = PyObject_CallObject(get_json_info_for, args);
    long size;
    char *char_result = PyUnicode_AsUTF8AndSize(py_result, &size);
    NSData *data_result = [NSData dataWithBytes:char_result length:strlen(char_result)];
    return data_result;
}

@end
