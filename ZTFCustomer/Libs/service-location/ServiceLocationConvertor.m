//
//  ServiceLocationConvertor.m
//
//  Created by QFish on 7/3/14.
//  Copyright (c) 2014 geek-zoo. All rights reserved.
//

#import "ServiceLocationConvertor.h"

static bool TransformOutOfChina(double lat, double lon);
static void WGS84TOGCJ02Transform(double wgLat, double wgLon, double * mgLat, double * mgLon);
static double WGS84TOGCJ02TransformLat(double x, double y);
static double WGS84TOGCJ02TransformLon(double x, double y);

const double pi = 3.14159265358979324;

//
// Krasovsky 1940
//
// a = 6378245.0, 1/f = 298.3
// b = a * (1 - f)
// ee = (a^2 - b^2) / a^2;
const double a = 6378245.0;
const double ee = 0.00669342162296594323;

//
// World Geodetic System ==> Mars Geodetic System
static void WGS84TOGCJ02Transform(double wgLat, double wgLon, double * mgLat, double * mgLon)
{
    if (TransformOutOfChina(wgLat, wgLon))
    {
        *mgLat = wgLat;
        *mgLon = wgLon;
        return;
    }
    double dLat = WGS84TOGCJ02TransformLat(wgLon - 105.0, wgLat - 35.0);
    double dLon = WGS84TOGCJ02TransformLon(wgLon - 105.0, wgLat - 35.0);
    double radLat = wgLat / 180.0 * pi;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
    *mgLat = wgLat + dLat;
    *mgLon = wgLon + dLon;
}

static bool TransformOutOfChina(double lat, double lon)
{
    if (lon < 72.004 || lon > 137.8347)
        return true;
    if (lat < 0.8293 || lat > 55.8271)
        return true;
    return false;
}

static double WGS84TOGCJ02TransformLat(double x, double y)
{
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
    return ret;
}

static double WGS84TOGCJ02TransformLon(double x, double y)
{
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
    return ret;
}

static void bd_encrypt(double gg_lat, double gg_lon, double * bd_lat, double * bd_lon)
{
    double x = gg_lon, y = gg_lat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * pi);
    *bd_lon = z * cos(theta) + 0.0065;
    *bd_lat = z * sin(theta) + 0.006;
}

static void bd_decrypt(double bd_lat, double bd_lon, double * gg_lat, double * gg_lon)
{
    double x = bd_lon - 0.0065, y = bd_lat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * pi);
    *gg_lon = z * cos(theta);
    *gg_lat = z * sin(theta);
}

#pragma mark -

CLLocationCoordinate2D ConvertLocationFromWGS84ToGCJ02(CLLocationCoordinate2D coordinate)
{
    double alat, alon;
    WGS84TOGCJ02Transform(coordinate.latitude, coordinate.longitude, &alat, &alon);
    return CLLocationCoordinate2DMake(alat, alon);
}

CLLocationCoordinate2D ConvertLocationFromGCJ02ToBD09LL(CLLocationCoordinate2D coordinate)
{
    double alat, alon;
    bd_encrypt(coordinate.latitude, coordinate.longitude, &alat, &alon);
    return CLLocationCoordinate2DMake(alat, alon);
}

CLLocationCoordinate2D ConvertLocationFromBD09LLToGCJ02(CLLocationCoordinate2D coordinate)
{
    double alat, alon;
    bd_decrypt(coordinate.latitude, coordinate.longitude, &alat, &alon);
    return CLLocationCoordinate2DMake(alat, alon);
}
