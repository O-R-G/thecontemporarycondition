// The Contemporary Condition 

import processing.sound.*;

SoundFile ding, dang, dong;

int x, y;
int h, m, s, ms; 
int hl, ml, sl; 
int lasthour;
int lastmin;
int lastsec;
int lastmilli;
int delta, gamma;
int speed;
int radius;
int rewindcounter;
int rewindduration;
int sweepspeed;

boolean rewinding;
boolean verbose = true;

void setup() {
    // size(960, 960); // [960, 960]
    size(480, 480);
    frameRate(60);
    noCursor();
    smooth();
	
	x = width / 2;
	y = width / 2;
    radius = int(width * .40);    

    hl = (int)(radius * 0.50);
    ml = (int)(radius * 0.80);
    sl = (int)(radius * 0.90);
    h = 0;
    m = 0;
    s = 0;

    speed = 5;
    delta = -(int)(3600 / (frameRate * speed));
    gamma = 0;

    rewindduration = 60;
    sweepspeed = 1000;

    ding = new SoundFile(this, "ding-44k.aif");
    dang = new SoundFile(this, "ding-44k.aif");
    dong = new SoundFile(this, "ding-44k.aif");
	dang.rate(.25);
	dong.rate(.125);
}

void draw() {
    background(0);
    drawHollows();
    noFill();
    stroke(255);

    float ha, ma, sa, msa;

    if (!rewinding) {
        h = hour();
        m = minute();
        s = second();
        ms = millis();
        lasthour = checkHour(h, lasthour);
        lastmin = checkMin(m, lastmin);
        lastsec = checkSec(s, lastsec);
        lastmilli = checkMillis(ms, sweepspeed);
	} else {
        rewind(h,m,s);  // could have this return values
    }

    // ha = map(h % 12 + ((float) m) / 60.0, 0, 12, 0, TWO_PI) - HALF_PI;
    // ma = map(m + ((float) s) / 60.0, 0, 60, 0, TWO_PI) - HALF_PI;
    sa = map(s, 0, 60, 0, TWO_PI) - HALF_PI;
    msa = map(ms, 0, sweepspeed, 0, TWO_PI) - HALF_PI;

    /*
    strokeWeight(3);
    ellipse(x, y, radius*2, radius*2);
    */
    strokeWeight(3);    // millisec
    line(x, x, cos(msa) * sl + x, sin(msa) * sl + y);
    /*
    strokeWeight(3);    // sec
    line(x, x, cos(sa) * sl + x, sin(sa) * sl + y);
    strokeWeight(5);    // min
    line(x, x, cos(ma) * ml + x, sin(ma) * ml + y);
    strokeWeight(5);    // hr
    line(x, x, cos(ha) * hl + x, sin(ha) * hl + y);
    */
}


// draw checkerboard

void drawHollows() {
    noStroke();
    int color1 = 0;       // * fix * these as data type color
    int color2 = 50;
    int counter = 0;
    int boxes = 10;
    // int boxsize = width/boxes;
    int boxsize = 20;
    for (int x = 0; x < width; x+=boxsize) {
        if (counter % 2 == 0) fill(color1);
        else fill(color2);
        for (int y = 0; y < height; y+=boxsize) {
            if (counter % 2 == 0) fill(color2);
            else fill(color1);
            rect(x, y, boxsize, boxsize);
            counter++;
        }
        rect(x, y, boxsize, boxsize);
        counter++;
    }
}


// animation

void rewind(int thish, int thism, int thiss) {
    s = (s + delta);        
    if (s >= 60)
        m += s / 60;
    if (m >= 60)
        h += m / 60;
    h = h % 12;
    m = m % 60;
    s = s % 60;
    s = (s + delta);
    if (s < 0) {
        m += (int) floor(((float) s ) / 60);
        s += 60;
    }
    if (m < 0) {
        h += (int) floor(((float) m ) / 60);
        m += 60;
    }
    if (h < 0) {
        h += 12;
    }
    delta += gamma;

    rewindcounter++;    
    if (rewindcounter % rewindduration == 0)
        rewinding = false;

    if (verbose)    
        println(h + ":" + m + ":" + s);
}


// timers

int checkHour(int thish, int thislasthour) {
    if (thish != thislasthour) {
        switch (thish) {
            case 0:
            case 12:
                if (!rewinding)
                    dong.play();
		        if (verbose) println("+ " + thish);
                thislasthour = thish;
                break;
            default:
                thislasthour = thish - 1;
                break;
		}
	}
	return thislasthour;
}

int checkMin(int thism, int thislastmin) {
	if (thism != thislastmin) {
		switch (thism) {            
            case 0:
                rewinding =! rewinding;
                ding.play();
                if (verbose) println("+ " + thism);
                thislastmin = thism;
                break;
            default:
                thislastmin = thism - 1;
                break;
		}
	}
	return thislastmin;
}

int checkSec(int thiss, int thislastsec) {
	if (thiss != thislastsec) {
        switch (thiss) {            
            case 0:
                if (verbose) println("+ " + thiss);
                thislastsec = thiss;
                break;
            default:
                thislastsec = thiss - 1;
                break;
		}
	}
    return thislastsec;
}

int checkMillis(int thisms, int thissweepspeed) {
    // adjust speed by modulo
    thisms%=thissweepspeed;
    // println("ms : " + thisms);
    println("sweepspeed : " + thissweepspeed);
    return thisms;
}

// utility

void keyPressed() {
    switch(key) {
        case 'd':
			ding.play();
            break;
        case 's':
			dang.play();
            break;
        case 'a':
			dong.play();
            break;
        case '=':
            sweepspeed+=10; 
            break;
        case '+':
            sweepspeed+=100; 
            break;
        case '-':
            sweepspeed-=10; 
            break;
        case '_':
            sweepspeed-=100; 
            break;
        case ' ':
            rewinding =! rewinding;
            dong.play();
            break;
        default:
            break;
	}
}

