#include <iostream>       // std::cout, std::cin, std::cerr
#include <cstdlib>        // std::atoi, std::malloc

//get frame from stdin
void getFrame(unsigned char frame[], int frameSide)
{
	//set local neccessary data
	int frameSize=frameSide*frameSide*3;
	unsigned char tmpFrame[frameSize];
	
	//read data as rgbrgbrgb...
	std::cin.read((char*)tmpFrame,frameSize);
	//change data to matlab's rrr...ggg...bbb...
	for(int i=0;i<frameSize;i++)
		frame[i]=tmpFrame[i*3+(i/(frameSize/3))*(1-frameSize)];
}

//this func makes **pointerTab for printFrame. Then outputFrame is prepared only once
void createPointerTab( unsigned char**pointerTab, unsigned char *tab,int side){
	int framesize=side*side*3*sizeof(*tab);
	int i,j,k;
	
	//Matlab's:rrr...ggg...bbb... to PNM's:rgbrgbrgb...
	for(i=0;i<framesize;i++)
		pointerTab[i*3+(i/(framesize/3))*(1-framesize)]=tab+i;
	
	//Vertical flipping
	unsigned char *tmp;
	for(i=0;i<side/2;i++){
		for(j=0;j<side*3;j++){
			tmp=pointerTab[i*side*3+j];
			pointerTab[i*side*3+j]=pointerTab[(side-i-1)*side*3+j];
			pointerTab[(side-i-1)*side*3+j]=tmp;
		}
	}
	
	//Rotationg 90-degrees clockwise
	unsigned char *rgb[3];
	for(i=0;i<side/2;i++){
		for(j=i;j<side-i-1;j++){
			for(k=0;k<3;k++){
				rgb[k]=pointerTab[i*side*3+j*3+k];
				pointerTab[i*side*3+j*3+k]=pointerTab[(side-1-j)*side*3+i*3+k];
				pointerTab[(side-1-j)*side*3+i*3+k]=pointerTab[(side-1-i)*side*3+(side-1-j)*3+k];
				pointerTab[(side-1-i)*side*3+(side-1-j)*3+k]=pointerTab[j*side*3+(side-1-i)*3+k];
				pointerTab[j*side*3+(side-1-i)*3+k]=rgb[k];
			}
		}
	}
	
}

//print frame
unsigned char**pointerFrame;
int pointerFrameSide=0;
void printFrame(unsigned char frame[], int frameSide){
	
	int framesize=frameSide*frameSide*3;
	//checking for differences with previous configuration
	
	if(pointerFrameSide!=frameSide || frame!=*pointerFrame){
		pointerFrame=(unsigned char**) std::malloc(framesize*sizeof(unsigned char**));
		createPointerTab(pointerFrame,frame,frameSide);
		pointerFrameSide=frameSide;
	}
	
	//printing
	unsigned char outFrame[framesize];
	for(int i=0;i<framesize;i++)
		outFrame[i]=*pointerFrame[i];
	std::cout.write((char*)outFrame,framesize);
}

//it prints message to cerr
void printErr(char errMsg[]){
	std::cerr<<errMsg;
}