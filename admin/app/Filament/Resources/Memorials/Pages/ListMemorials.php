<?php

namespace App\Filament\Resources\Memorials\Pages;

use App\Filament\Resources\Memorials\MemorialResource;
use Filament\Actions\CreateAction;
use Filament\Resources\Pages\ListRecords;

class ListMemorials extends ListRecords
{
    protected static string $resource = MemorialResource::class;

    protected function getHeaderActions(): array
    {
        return [
            CreateAction::make(),
        ];
    }
}
