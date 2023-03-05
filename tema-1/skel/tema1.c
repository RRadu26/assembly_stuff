#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_INPUT_LINE_SIZE 300

struct Dir;
struct File;

typedef struct Dir{
	char *name;
	struct Dir* parent;
	struct File* head_children_files;
	struct Dir* head_children_dirs;
	struct Dir* next;
} Dir;

typedef struct File {
	char *name;
	struct Dir* parent;
	struct File* next;
} File;
void init(Dir **home)
{
	(*home)=(Dir*)malloc(sizeof(Dir));
	(*home)->name=calloc(sizeof("home"),1);

	strcat((*home)->name,"home");
	(*home)->head_children_files=NULL;
	(*home)->head_children_dirs=NULL;
	(*home)->parent=NULL;

}
void quit(Dir *d)
{
	if(!d)
		return;
	File *f= d->head_children_files;
	File *df;

	while(f)
	{
		df=f;
		f=f->next;
		df->parent=NULL;
		free(df->name);
		free(df);
	}
	Dir *dd=d->head_children_dirs;
	Dir *x;

	while(dd)
	{
		x=dd->next;
		quit(dd);
		dd=x;
	}
	free(d->name);
	free(d);
}
Dir *createdir(char *name,Dir *parent)
{
	Dir *d=(Dir*)malloc(sizeof(Dir));
	d->name=calloc(sizeof(name),1);
	
	strcat(d->name,name);
	d->parent=parent;
	d->next=NULL;
	d->head_children_files=NULL;
	d->head_children_dirs=NULL;
	return d;
}
File *createfile(char *name,Dir* parent )
{
	File *f=(File*)malloc(sizeof(File));
	f->name=calloc(sizeof(name),1);
	strcat(f->name,name);
	f->parent=parent;
	f->next=NULL;
	return f;

}
void mkdir(Dir *parent,char* name)
{
	Dir *d=parent->head_children_dirs;
	Dir *p=NULL;

	if(d)
	{
		while(d)
		{
			if(strcmp(d->name , name) == 0)
			{
				printf("Directory already exists\n");
				return;
			}
			p=d;
			d=d->next;
			
		}
		p->next=createdir(name,parent);
	}
	else
	{
		parent->head_children_dirs=createdir(name,parent);
	}
}
void touch (Dir* parent,char* name) 
{
	File *d=parent->head_children_files;
	File *p=NULL;

	if(d)
	{
		while(d)
		{
			if(strcmp(d->name , name) == 0)
			{
				printf("File already exists\n");
				return;
			}
			p=d;
			d=d->next;
			
		}
		p->next=createfile(name,parent);
	}
	else
	{
		parent->head_children_files=createfile(name,parent);
	}
}

void ls (Dir* parent) {
	Dir *d=parent->head_children_dirs;
	File *f=parent->head_children_files;
	while(d)
	{
		printf("%s\n",d->name);
		d=d->next;
	}
	while(f)
	{
		printf("%s\n",f->name);
		f=f->next;
	}
}

void rm (Dir* parent, char* name) 
{
	File *f=parent->head_children_files;
	File *prev=NULL;
	if(f == NULL)
	{
		printf("Could not find the file\n");
		return;
	}
	if(strcmp(f->name,name)==0)
	{
		File *f2=f->next;
		free(f->name);
		free(f);
		parent->head_children_files=f2;
		return;
	}
	while(f && strcmp(f->name,name)!=0)
	{
		prev=f;
		f=f->next;
	}
	if(f==NULL)
	{
		printf("Could not find the file\n");
		return;
	}
	prev->next=f->next;
	free(f->name);
	free(f);
}
void rmdir (Dir* parent, char* name) 
{
	Dir *d=parent->head_children_dirs;
	Dir *prev=NULL;
	if(d==NULL)
	{
		printf("Could not find the dir\n");
		return;
	}
	if(strcmp(d->name,name)==0)
	{
		Dir *d2=d->next;
		quit(d);
		parent->head_children_dirs=d2;
		return;
	}
	while(d && strcmp(d->name,name)!=0)
	{
		prev=d;
		d=d->next;
	}
	if(d==NULL)
	{
		printf("Could not find the dir\n");
		return;
	}
	prev->next=d->next;
	quit(d);

}

void cd(Dir** target, char *name) {
	Dir *d=(*target)->head_children_dirs;
	if(!d && strcmp(name,"..")!=0)
	{
		printf("No directories found!\n");
		return;
	}
	if(strcmp(name,"..")==0)
	{
		if((*target)->parent)
			(*target)=(*target)->parent;	
		return;
	}
	while(d)
	{
		if(strcmp(d->name,name)==0)
		{
			(*target)=d;
			return;
		}
		d=d->next;
	}
	printf("No directories found!\n");

}

char *pwd (Dir* target) {
	char *s=(char*)calloc(sizeof(target->name)+1,1);
	strcpy(s,"/");
	strcat(s,target->name);
	Dir *d=target->parent;
	while(d)
	{
		char *tmp=calloc(sizeof(s)+sizeof(d->name)+5,1);
		strcpy(tmp,"/");
		strcat(tmp,d->name);
		strcat(tmp,s);
		char *t=s;
		s=tmp;
		free(t);
		d=d->parent;
	}
	return s;

}

void stop (Dir* target) {}

void tree (Dir* target, int level) 
{
	if(!target)
		return;

	Dir *d=target->head_children_dirs;
	while(d)
	{
		int i;
		for(i=0;i<4*level;i++)
			printf(" ");
		printf("%s\n",d->name);
		tree(d,level+1);
		d=d->next;
	}
	File *f=target->head_children_files;
	while(f)
	{
		int i;
		for(i=0;i<4*level;i++)
			printf(" ");
		printf("%s\n",f->name);
		f=f->next;
	}
}

void mv(Dir* parent, char *oldname, char *newname) 
{
	File *f=parent->head_children_files;
	File *fg=NULL;
	Dir *dg=NULL;
	while(f)
	{
		if(strcmp(f->name,oldname)==0)
			fg=f;
		if(strcmp(f->name,newname)==0)
		{
			printf("File/Director already exists\n");
			return;
		}
		f=f->next;
	}
	Dir *d=parent->head_children_dirs;
	while(d)
	{
		if(strcmp(d->name,oldname)==0)
			dg=d;
		if(strcmp(d->name,newname)==0)
		{
			printf("File/Director already exists\n");
			return;
		}
		d=d->next;
	}
	if(!dg&&!fg)
	{
		printf("File/Director not found\n");
		return;
	}
	if(fg)
	{
		rm(parent,fg->name);
		touch(parent,newname);
		return;
	}
	if(dg)
	{
		rmdir(parent,dg->name);
		mkdir(parent,newname);
		return;
	}

}

void command(Dir **current,char *cmd,char *wds,int *run)
{
	if(strcmp(cmd,"stop")==0)
		*run=0;
	if(strcmp(cmd , "ls")==0)
		ls(*current);
	else if(strcmp(cmd , "touch")==0)
		touch(*current , wds);
	else if(strcmp(cmd , "mkdir")==0)
		mkdir(*current , wds);
	else if(strcmp(cmd,"rm")==0)
		rm(*current, wds);
	else if(strcmp(cmd,"rmdir")==0)
		rmdir(*current, wds);
	else if(strcmp(cmd,"cd")==0)
		cd(current,wds);
	else if(strcmp(cmd,"tree")==0)
		tree(*current,0);
	else if(strcmp(cmd,"pwd")==0)
	{
		char *s=pwd(*current);
		printf("%s\n",s);
		free(s);
	}

}

int main () {
	int run = 1;
	Dir *home=NULL;
	init(&home);
	Dir *current=home;
	do
	{
		char *t=(char*)malloc(MAX_INPUT_LINE_SIZE*sizeof(char)); 
		fgets(t,MAX_INPUT_LINE_SIZE,stdin);
		char *cmd=strtok(t , "  \n");
		if(strcmp(cmd,"mv")!=0)
		command(&current,cmd,strtok(NULL,"  \n"),&run);
		else
		{
			char *on=strtok(NULL,"  \n");
			char *nn=strtok(NULL,"  \n");
			mv(current,on,nn);
			
		}
		free(t);
	}
	while(run);
	quit(home);
	return 0;
}
