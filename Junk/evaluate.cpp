#include<stdio.h>	
#include<stdlib.h>
#include<fstream>

using namespace std;

int first_grid_number[12],first_grid_pos[12],second_grid_number[24],second_grid_sum[24];
double time_on[24],time_off[24],buzzer_on[24],buzzer_off[24],buzzer_diff[24],start,end;

void read_grid1()
{
	ifstream input_stream;
	input_stream.open("grid1_number.txt");
	int no,d=0,i;
	for(i=0;i<12;i++)
		first_grid_pos[i]=0;
	if(input_stream.is_open())
	{
		while(!input_stream.eof())
		{
			input_stream>>no;
			first_grid_number[d]=no;
			d++;
		}
		input_stream.close();
	}
	else
		printf("Unable to open grid1_number.txt\n");
}
int read_grid2()
{
	ifstream input_stream;
	input_stream.open("grid2_number.txt");
	int no,d=0,pos;
	for(d=0;d<24;d++)
	{
		second_grid_number[d]=0;
		second_grid_sum[d]=0;
	}
	d=0;
	if(input_stream.is_open())
	{
		while(!input_stream.eof())
		{
			input_stream>>pos;
			input_stream>>no;
			second_grid_number[pos-1]=no;
			d++;
		}
		input_stream.close();
	}
	else
	{
		printf("Unable to open grid2_number.txt\n");
		d=-1;
	}
	return d;
}

int read_ledinput()
{
	ifstream input_stream;
	input_stream.open("in.txt");
	int h2,h4,i,d=1,diff=-1;
	double h1,h3;
	
	i=1;
	while(buzzer_diff[i]<4)
		i++;
	if(i>buzzer_diff[0])
	{
		start=0;
		end=600;
	}
	else
	{
		start=buzzer_off[i];
		i++;
		if(i<buzzer_diff[0])
			while(buzzer_diff[i]<4)
				i++;
		if(i>buzzer_diff[0])
			end=600;
		else
			end=buzzer_on[i];
	}
		
	if(input_stream.is_open())
	{
		while(!input_stream.eof())
		{
			input_stream>>h1;
			input_stream>>h2;
			input_stream>>h3;
			input_stream>>h4;
			if(!(h1<start || h4>end))
			{
				time_on[d]=h1;
				time_on[0]=d;
			
				time_off[d]=h3;
				time_off[0]=d;
			
				if(first_grid_pos[h2-1]==0)
				{
					first_grid_pos[h2-1]=1;
					
					second_grid_sum[h4-1]+=first_grid_number[h2-1];
				}
			}
		}
		for(i=0;i<24;i++)
			if(second_grid_number[i]>0)
				diff+=abs(second_grid_number[i]-second_grid_sum[i]);
		input_stream.close();
	}
	else
	{
		printf("Unable to open file led input\n");
		diff=-1;
	}
	return diff;
}

void read_buzzerinput()
{
	ifstream input_stream;
	input_stream.open("buzzin.txt");
	int d=1;
	double t,on,off;
	if(input_stream.is_open())
	{
		while(!input_stream.eof())
		{
			input_stream>>on;
			input_stream>>off;
			buzzer_on[d]=on;
			buzzer_off[d]=off;
			buzzer_diff[d]=buzzer_off[d]-buzzer_on[d];
			buzzer_on[0]=d;
			buzzer_off[0]=d;
			buzzer_diff[0]=d;
			d++;
		}
		input_stream.close();
	}
	else
		printf("Unable to open file buzzer input\n");
	
}
void evaluate(int grid2,int diff)
{
	double T,time_score,correct_deposition_score=0,total_score,total_penalty,bonus=100;
	int k,k1,i,j,pen=0,found;
	
	T=end-start;
	correct_deposition_score=100*grid2;
	
	correct_deposition_score-=diff*10;
	
	time_score=600-T;
	
	k=1;k1=1;
	for(i=1;i<=time_on[0];i++)
	{
		//time_on[i]
		found=0;
		for(j=k;j<=time_on[0];j++)
		{
			if(abs(time_on[i]-buzzer_on[j])<2)
			{
				k=j;
				found=1;
				break;
			}
		}
		if(found==0)
			pen++;
			
		//time_off[i]
		found=0;
		for(j=k1;j<=time_on[0];j++)
		{
			if(abs(time_on[i]-buzzer_on[j])<2)
			{
				k1=j;
				found=1;
				break;
			}
		}
		if(found==0)
			pen++;
	}
	total_penalty=30*pen;
	
	if(total_penalty==0 && diff==0)
		bonus=100;
	else
		bonus=0;
	
	total_score=time_score+correct_deposition_score+bonus-total_penalty;
	
	printf("Time score=%llf\n",time_score);
	printf("Correct Deposition score=%llf\n",correct_deposition_score);
	printf("Penalty=%llf\n",total_penalty);
	printf("Bonus=%llf\n",bonus);
	printf("--------------------------------\n");
	printf("Total score=%llf",total_score);
}
int main()
{
	read_grid1();
	read_buzzerinput();
	int grid2=read_grid2();
	int diff=read_ledinput();
	printf("%d\n",diff);
	evaluate(grid2,diff);
	return 0;
}
