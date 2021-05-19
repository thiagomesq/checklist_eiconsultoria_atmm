import 'package:flutter/material.dart';

const eiConsultoriaGreen = Color(0xff75b631);
const eiConsultoriaLightGreen = Color(0xffeee8aa);
const eiConsultoriaBlue = Color(0xff34598d);
const eiConsultoriaSilver = Color(0xffc0c0c0);
const eiConsultoriaRed = Color(0xff8b0000);

const headerVeiculoTable = <DataColumn>[
  DataColumn(
    label: Text(
      'Empresa',
      style: tableHeaderTextStyle,
    ),
  ),
  DataColumn(
    label: Text(
      'Placa',
      style: tableHeaderTextStyle,
    ),
  ),
  DataColumn(
    label: Text(
      'Ano',
      style: tableHeaderTextStyle,
    ),
  ),
  DataColumn(
    label: Text(
      'Tipo',
      style: tableHeaderTextStyle,
    ),
  ),
];

const headerNaoConformidadeTable = <DataColumn>[
  DataColumn(
    label: Text(
      'Itens de Verificação',
      style: tableHeaderTextStyle,
    ),
  ),
  DataColumn(
    label: Text(
      'Descrição',
      style: tableHeaderTextStyle,
    ),
  ),
];

const headerVeiculosInseridosTable = <DataColumn>[
  DataColumn(
    label: Text(
      'Veículo',
      style: tableHeaderTextStyle,
    ),
  ),
  DataColumn(
    label: Text(
      'Empresa',
      style: tableHeaderTextStyle,
    ),
  ),
  DataColumn(
    label: Text(
      'NC\'s',
      style: tableHeaderTextStyle,
    ),
  ),
  DataColumn(
    label: Text(
      'Localidade',
      style: tableHeaderTextStyle,
    ),
  ),
  DataColumn(
    label: Text(
      'Detalhamento',
      style: tableHeaderTextStyle,
    ),
  ),
];

const tableHeaderTextStyle = TextStyle(
  fontStyle: FontStyle.italic,
  fontWeight: FontWeight.bold,
  color: eiConsultoriaGreen,
);

const paginationSelectableRowCount = <int>[
  5,
  10,
  25,
  50,
];
