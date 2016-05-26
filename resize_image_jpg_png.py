#
# Michele Campus (campus@ntop.org)
#
# python module to resize images without distortion
#
import PIL
from PIL import Image
import os
import glob
import imghdr as ih


path_src = os.getcwd() + '/my_src_dir/'
path_dst = os.getcwd() + '/my_dest_dir/'


""" Check images format (jpg, png allowed)
Args:
     image_dir:  String - path to the source directory.
"""
def check_image_format(image_dir):

    for root, dirs, files in os.walk(image_dir):
        for image in files:
            # print(image)
            ext = ih.what(os.path.join(root, image))
            # print(ext)
            if (ext != 'jpeg' and ext != 'png'):
                return -1
    return 0


### MAIN ###
def main():

    ret = check_image_format(path_src)

    if(ret == -1):
        print ("Some images are in incorrect format")
        return -1
    else:
        i = 0
        for dirName, subdirList, fileList in os.walk(path_src):
            for img in fileList:
                filepath = os.path.join(dirName, img)
                basewidth = 200
                img = Image.open(filepath)
                wpercent = (basewidth/float(img.size[0]))
                hsize = int((float(img.size[1])*float(wpercent)))
                img = img.resize((basewidth,hsize), PIL.Image.ANTIALIAS)
                i += 1
                img.save(os.path.join(path_dst,"foo"+str(i)+".jpeg"))
            
        print("Images resized correctly")

    return 0


if __name__ == '__main__':
    main()
