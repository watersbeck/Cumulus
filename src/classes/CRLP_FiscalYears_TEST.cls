/*
    Copyright (c) 2018, Salesforce.org
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Salesforce.org nor the names of
      its contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
    FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
    COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
    INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
    BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
    LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
    ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
    POSSIBILITY OF SUCH DAMAGE.
*/
/**
* @author Salesforce.org
* @date 2018
* @group Selectors
* @description Unit Test for the Fiscal Years class
*/
@isTest(IsParallel=true)
private class CRLP_FiscalYears_TEST {

    /*********************************************************************************************************
    * @description For a given date, test to see if fiscal year is correctly calculated based on all
    * combinations of org fiscal year settings
    */
    static testMethod void testGetFiscalYearForDate() {

        // ----------------------------------------------------------------------------
        // Use Calendar Year information
        // ----------------------------------------------------------------------------
        CRLP_FiscalYears fiscalYrs = new CRLP_FiscalYears(false);

        // Calendar Year based
        System.assertEquals(2014, fiscalYrs.getYear(Date.newInstance(2014, 1, 1)));
        System.assertEquals(2014, fiscalYrs.getYear(Date.newInstance(2014, 10, 1)));

        // ----------------------------------------------------------------------------
        // Switch to using the Organization Fiscal Information
        // ----------------------------------------------------------------------------
        fiscalYrs = new CRLP_FiscalYears(true);
        CRLP_FiscalYears.fiscalYearInfo.fiscalYearStartMonth = 4;               // Fiscal Year starts on 4/1
        CRLP_FiscalYears.fiscalYearInfo.usesStartDateAsFiscalYearName = false;  // Fiscal Year is based on end date

        // Target date is in fiscal year Apr through Mar, year comes from end
        System.assertEquals(2015, fiscalYrs.getYear(Date.newInstance(2014, 4, 1)));
        System.assertEquals(2015, fiscalYrs.getYear(Date.newInstance(2014, 5, 1)));
        System.assertEquals(2015, fiscalYrs.getYear(Date.newInstance(2015, 3, 1)));
        System.assertEquals(2016, fiscalYrs.getYear(Date.newInstance(2015, 4, 1)));

        CRLP_FiscalYears.fiscalYearInfo.fiscalYearStartMonth = 4;               // Fiscal Year starts on 4/1
        CRLP_FiscalYears.fiscalYearInfo.usesStartDateAsFiscalYearName = true;   // Fiscal Year is based on start date

        // Target date is in fiscal year Apr through Mar, year comes from Start
        System.assertEquals(2014, fiscalYrs.getYear(Date.newInstance(2014, 4, 1)));
        System.assertEquals(2014, fiscalYrs.getYear(Date.newInstance(2014, 5, 1)));
        System.assertEquals(2014, fiscalYrs.getYear(Date.newInstance(2015, 3, 1)));
        System.assertEquals(2015, fiscalYrs.getYear(Date.newInstance(2015, 12, 1)));
    }
}