// Copyright (c) 2011-2014 The Bitcoin Core developers
// Copyright (c) 2017-2019 The Raven Core developers
// Copyright (c) 2020-2021 The Virtualempire Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#ifndef VIRTUALEMPIRE_QT_VIRTUALEMPIREADDRESSVALIDATOR_H
#define VIRTUALEMPIRE_QT_VIRTUALEMPIREADDRESSVALIDATOR_H

#include <QValidator>

/** Base58 entry widget validator, checks for valid characters and
 * removes some whitespace.
 */
class VirtualempireAddressEntryValidator : public QValidator
{
    Q_OBJECT

public:
    explicit VirtualempireAddressEntryValidator(QObject *parent);

    State validate(QString &input, int &pos) const;
};

/** virtualempire address widget validator, checks for a valid virtualempire address.
 */
class VirtualempireAddressCheckValidator : public QValidator
{
    Q_OBJECT

public:
    explicit VirtualempireAddressCheckValidator(QObject *parent);

    State validate(QString &input, int &pos) const;
};

#endif // VIRTUALEMPIRE_QT_VIRTUALEMPIREADDRESSVALIDATOR_H
