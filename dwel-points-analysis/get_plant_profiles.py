import numpy as np
import csv

def get_plant_profiles(rowmidzeniths,heights,pgapz):

    # Initialise output dictionary
    profiles = dict()
    profiles["heights"] = heights
    
    # Hinge point PAI    
    # hingeindex = np.argmin(np.abs(rowmidzeniths - np.arctan(np.pi / 2)))
    # profiles["hingePAI"] = -1.1 * np.log(pgapz[hingeindex,:])

    # Linear model PAI
    kthetal = -np.log(pgapz) #* np.cos(rowmidzeniths)
    xtheta = 2 * np.tan(rowmidzeniths) / np.pi
    PAIv = np.zeros(len(heights))
    PAIh = np.zeros(len(heights))
    for i,h in enumerate(heights):    
        A = np.vstack([xtheta, np.ones(xtheta.size)]).T
        y = kthetal[:,i]
        if y.any():
            Lv, Lh = np.linalg.lstsq(A, y)[0]        
            PAIv[i] = Lv
            PAIh[i] = Lh
    profiles["ePAI"] = PAIv + PAIh
    profiles["MLA"] = 90 - np.degrees(np.arctan2(PAIv,PAIh))

    # get PAVD
    profiles["ePAVD"] = ( (profiles["ePAI"])[1:len(heights)-1]-(profiles["ePAI"])[0:len(heights)-2] ) / \
                        (heights[1:len(heights)-1]-heights[0:len(heights)-2])
    
    return profiles
    
def __main__():
    midzeniths=[]
    fzen = open('midzeniths.txt', 'r')
    for line in fzen:
        midzeniths.append(float(line))
    fzen.close()
    fzen = np.array(fzen)
    
    heights=[]
    fheights = open('heights.txt', 'r')
    for line in fheights:
        heights.append(float(line))
    fheights.close()
    heights = np.array(heights)

    pgapz_leaf = []
    with open('pgapz_leaf.txt', 'r') as leaffile:
        leafreader = csv.reader(leaffile, delimiter=',')
        for row in leafreader:
            pgapz_leaf.append([float(x) for x in row])
    pgapz_leaf = np.array(pgapz_leaf)

    pgapz_branch = []
    with open('pgapz_branch.txt', 'r') as branchfile:
        branchreader = csv.reader(branchfile, delimiter=',')
        for row in branchreader:
            pgapz_branch.append([float(x) for x in row])
    pgapz_branch = np.array(pgapz_branch)
    
    leaf = get_plant_profiles(midzeniths, heights, pgapz_leaf)
    with open('leafprofile.txt', 'w') as leafprofile:
        for i in np.arange(heights.size-2):
            leafprofile.write( str(heights[i])+','+str(leaf["ePAI"][i])+','+str(leaf["MLA"][i])+','+str(leaf["ePAVD"][i])+'\n' )

    branch = get_plant_profiles(midzeniths, heights, pgapz_branch)
    with open('branchprofile.txt', 'w') as branchprofile:
        for i in np.arange(heights.size-2):
            branchprofile.write( str(heights[i])+','+str(branch["ePAI"][i])+','+str(branch["MLA"][i])+','+str(branch["ePAVD"][i])+'\n' )

if __name__ == "__main__":
    __main__()
